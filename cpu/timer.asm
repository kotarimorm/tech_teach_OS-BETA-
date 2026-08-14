; ============================================================
; File: cpu/timer.asm
; Topic: Programmable Interval Timer (PIT)
; Type: Reference snippet
;
; Purpose:
;   Programs PIT channel 0 to generate timer interrupts at an
;   approximate requested frequency.
;
; Environment:
;   - 32-bit x86 protected mode
;   - Ring 0 / permission to access I/O ports
;   - Legacy PIT available
;
; Does not:
;   - Install an IRQ0 handler
;   - Configure or unmask the PIC
;   - Enable interrupts
;
; Contract:
;   Input:
;     EAX = requested frequency in Hz
;
;   Success:
;     CF  = 0
;     EAX = actual programmed frequency, rounded down to integer Hz
;
;   Failure:
;     CF  = 1
;     EAX = 0
;
;   Preserved:
;     EBX, ECX, EDX
;
;   Modified:
;     EAX, EFLAGS
; ============================================================

[bits 32]

PIT_COMMAND_PORT  equ 0x43
PIT_CHANNEL_0     equ 0x40
PIT_BASE_FREQ     equ 1193180
PIT_MIN_FREQ      equ 19
PIT_MAX_FREQ      equ PIT_BASE_FREQ
PIT_MAX_DIVISOR   equ 65535

section .text

global init_timer

; ------------------------------------------------------------
; init_timer
;
; Example:
;
;     mov eax, 100
;     call init_timer
;     jc .timer_error
;
; On success, EAX contains the actual configured frequency.
; ------------------------------------------------------------

init_timer:
    push ebx
    push ecx
    push edx

    ; Reject frequencies outside the documented range.
    cmp eax, PIT_MIN_FREQ
    jb .invalid_frequency

    cmp eax, PIT_MAX_FREQ
    ja .invalid_frequency

    ; divisor = PIT_BASE_FREQ / requested_frequency
    mov ecx, eax
    mov eax, PIT_BASE_FREQ
    xor edx, edx
    div ecx

    ; Defensive validation. A zero divisor would be interpreted
    ; by the PIT as 65536 and produce an unexpected low frequency.
    test eax, eax
    jz .invalid_frequency

    cmp eax, PIT_MAX_DIVISOR
    jbe .divisor_ready

    mov eax, PIT_MAX_DIVISOR

.divisor_ready:
    mov ebx, eax

    ; Channel 0, low/high byte access, mode 3, binary counter.
    mov dx, PIT_COMMAND_PORT
    mov al, 0x36
    out dx, al

    ; Send divisor low byte followed by high byte.
    mov dx, PIT_CHANNEL_0
    mov al, bl
    out dx, al

    mov al, bh
    out dx, al

    ; Report the actual resulting integer frequency.
    mov ecx, ebx
    mov eax, PIT_BASE_FREQ
    xor edx, edx
    div ecx

    clc
    jmp .done

.invalid_frequency:
    xor eax, eax
    stc

.done:
    pop edx
    pop ecx
    pop ebx
    ret
