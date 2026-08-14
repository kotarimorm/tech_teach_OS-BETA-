; ============================================================
; File: interrupts/idt.asm
; Topic: Interrupt Descriptor Table
; Type: Reference snippet
;
; Environment:
;   - 32-bit x86 protected mode
;   - Kernel code selector is 0x08
;   - Interrupts are disabled during configuration
;
; Required order:
;   1. call clear_idt
;   2. install valid exception and IRQ handlers
;   3. call load_idt
;   4. configure PIC
;   5. enable interrupts only when everything is ready
; ============================================================

[bits 32]

IDT_ENTRY_COUNT       equ 256
IDT_ENTRY_SIZE        equ 8
KERNEL_CODE_SELECTOR  equ 0x08
INTERRUPT_GATE_FLAGS  equ 0x8E

section .bss
align 16

idt_table:
    resb IDT_ENTRY_COUNT * IDT_ENTRY_SIZE

section .data
align 4

idtr:
    dw (IDT_ENTRY_COUNT * IDT_ENTRY_SIZE) - 1
    dd idt_table

section .text

global clear_idt
global set_idt_gate
global load_idt

; ------------------------------------------------------------
; clear_idt
;
; Clears all 256 IDT entries.
;
; Preserves:
;   EAX, ECX, EDI, EFLAGS
; ------------------------------------------------------------

clear_idt:
    pushfd
    push eax
    push ecx
    push edi

    cld
    mov edi, idt_table
    xor eax, eax
    mov ecx, (IDT_ENTRY_COUNT * IDT_ENTRY_SIZE) / 4
    rep stosd

    pop edi
    pop ecx
    pop eax
    popfd
    ret

; ------------------------------------------------------------
; set_idt_gate
;
; Input:
;   EAX = handler address
;   EBX = vector number (0..255)
;
; Success:
;   CF = 0
;
; Failure:
;   CF = 1 when vector number is outside the IDT
;
; Preserves:
;   EAX, EBX, EDX, EDI
;
; Warning:
;   The handler must be valid before this gate can be triggered.
; ------------------------------------------------------------

set_idt_gate:
    cmp ebx, IDT_ENTRY_COUNT - 1
    ja .invalid_vector

    push eax
    push edx
    push edi

    mov edi, idt_table
    lea edi, [edi + ebx * IDT_ENTRY_SIZE]

    mov edx, eax

    ; Handler offset bits 0..15
    mov word [edi], dx

    ; Kernel code segment
    mov word [edi + 2], KERNEL_CODE_SELECTOR

    ; Reserved byte
    mov byte [edi + 4], 0

    ; Present, ring 0, 32-bit interrupt gate
    mov byte [edi + 5], INTERRUPT_GATE_FLAGS

    ; Handler offset bits 16..31
    shr edx, 16
    mov word [edi + 6], dx

    pop edi
    pop edx
    pop eax

    clc
    ret

.invalid_vector:
    stc
    ret

; ------------------------------------------------------------
; load_idt
;
; Loads IDTR with the address and size of idt_table.
;
; Warning:
;   Loading the IDT does not make empty entries safe.
;   Install handlers before enabling interrupts.
; ------------------------------------------------------------

load_idt:
    lidt [idtr]
    ret
