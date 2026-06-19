# OSDev Reference Map

> Quick navigation map for the `tech_teach_OS` reference stand.

This repository is a collection of independent OSDev reference files.

The files are **not intended to compile together as one operating system**.

Use this map to quickly find the file related to the topic or bug you are working on.

---

## CPU Setup

| Topic | File | Purpose |
|---|---|---|
| GDT | `cpu/gdt.asm` | Basic Global Descriptor Table setup |
| Paging | `cpu/paging.asm` | Minimal identity paging example |
| PMM | `cpu/pmm.asm` | Bitmap physical memory manager experiment |
| PIT Timer | `cpu/timer.asm` | Programmable Interval Timer setup |
| I/O Ports | `cpu/ports.asm` | I/O port helper macros |

---

## Interrupts

| Topic | File | Purpose |
|---|---|---|
| IDT | `interrupts/idt.asm` | Interrupt Descriptor Table helpers |
| ISR | `interrupts/isr.asm` | Interrupt Service Routine examples |
| PIC | `interrupts/pic.asm` | Legacy PIC remapping example |

---

## Drivers

| Topic | File | Purpose |
|---|---|---|
| VGA Text | `drivers/vga.asm` | Minimal VGA text mode output |
| PS/2 Keyboard | `drivers/keyboard/keyboard.asm` | Keyboard IRQ1 handler experiment |
| Keyboard Buffer | `drivers/kbd_buffer.asm` | Circular keyboard input buffer |
| Scancodes | `drivers/keyboard/Scancode.md` | PS/2 Set 1 scancode reference |
| ATA PIO | `drivers/disk/ATA.asm` | ATA PIO sector read example |
| PCI | `drivers/pci.asm` | PCI bus scanning via CF8/CFC |
| Driver Manager | `drivers/manager/manager.asm` | Table-based driver init concept |
| Driver Stubs | `drivers/manager/drivers.asm` | Placeholder driver init/handler routines |

---

## Kernel Concepts

| Topic | File | Purpose |
|---|---|---|
| Panic | `kernel/panic.asm` | VGA panic screen helper |
| Scheduler | `kernel/scheduler.asm` | Context-switching experiment |

---

## Libraries

| Topic | File | Purpose |
|---|---|---|
| Memory | `lib/memory.asm` | Basic `memcpy` / `memset` helpers |
| Print | `lib/print.asm` | Hex byte print helper |

---

## Debugging

| Topic | File | Purpose |
|---|---|---|
| Triple Fault | `debug/triple_fault.md` | Triple fault checklist |
| Troubleshooting | `debug/troubleshooting.md` | General kernel debugging flow |

---

## Find By Problem

| Problem / Goal | Start Here |
|---|---|
| Need protected mode segments | `cpu/gdt.asm` |
| Need interrupt table setup | `interrupts/idt.asm` |
| Need interrupt handler examples | `interrupts/isr.asm` |
| Need to remap hardware IRQs | `interrupts/pic.asm` |
| Kernel instantly reboots | `debug/triple_fault.md` |
| Interrupts enabled too early | `debug/triple_fault.md` |
| Forgot `iret` / bad ISR return | `interrupts/isr.asm` |
| Keyboard IRQ does nothing | `drivers/keyboard/keyboard.asm` + `interrupts/pic.asm` |
| Need keyboard scancode values | `drivers/keyboard/Scancode.md` |
| Need basic VGA output | `drivers/vga.asm` |
| Need panic output | `kernel/panic.asm` |
| Need PIT timer setup | `cpu/timer.asm` |
| Need ATA PIO sector read | `drivers/disk/ATA.asm` |
| Need PCI scanning idea | `drivers/pci.asm` |
| Need memory copy/fill helpers | `lib/memory.asm` |
| Need physical page allocation idea | `cpu/pmm.asm` |
| Need general debugging flow | `debug/troubleshooting.md` |

---

## Snippet Status

This section describes the current role and maturity of each reference file in the repository.

The files are independent by design and are not intended to compile together as one OS.

| File | Status | Notes |
|---|---|---|
| `README.md` | Project overview | Explains the purpose, scope, and philosophy of the repository. |
| `MAP.md` | Navigation | Quick map for finding the right reference file by topic or problem. |
| `cpu/gdt.asm` | Reference | Minimal flat GDT setup for 32-bit protected mode experiments. |
| `cpu/paging.asm` | Experimental | Basic identity paging example; not a complete virtual memory manager. |
| `cpu/pmm.asm` | Unsafe demo | Bitmap-based PMM; does not parse memory maps or reserve kernel regions automatically. |
| `cpu/ports.asm` | Utility | Small I/O port helper macros for low-level hardware access. |
| `cpu/timer.asm` | Reference | PIT timer configuration example; does not install IRQ handlers by itself. |
| `interrupts/idt.asm` | Reference | IDT storage and gate setup helpers; requires valid handlers before interrupts are enabled. |
| `interrupts/isr.asm` | Reference | Basic ISR examples for timer, keyboard, and exceptions. |
| `interrupts/pic.asm` | Reference | Legacy PIC remapping example for moving IRQs away from CPU exception vectors. |
| `drivers/vga.asm` | Reference | Minimal VGA text mode output; no scrolling, newline handling, or bounds checks. |
| `drivers/kbd_buffer.asm` | Utility | Simple circular keyboard buffer for early input experiments. |
| `drivers/keyboard/keyboard.asm` | Experimental | PS/2 keyboard IRQ1 handler; requires scancode translation and kernel integration. |
| `drivers/keyboard/Scancode.md` | Notes | Reference notes for keyboard scancodes. |
| `drivers/disk/ATA.asm` | Unsafe demo | Minimal ATA PIO sector read example; lacks full timeout and error handling. |
| `drivers/pci.asm` | Experimental | Basic PCI bus scanning via CF8/CFC configuration ports. |
| `drivers/manager/manager.asm` | Concept | Simple table-based driver initialization idea. |
| `drivers/manager/drivers.asm` | Stub | Placeholder driver init/handler routines for manager experiments. |
| `kernel/panic.asm` | Debug helper | Minimal VGA panic output that disables interrupts and halts. |
| `kernel/scheduler.asm` | Experimental | Early context-switching idea; not a complete scheduler. |
| `lib/memory.asm` | Utility | Basic `memcpy` / `memset` routines; no bounds checking or overlap handling. |
| `lib/print.asm` | Utility | Hex byte print helper; depends on an external `print_char` implementation. |
| `debug/triple_fault.md` | Debug guide | Focused checklist for diagnosing triple faults and instant resets. |
| `debug/troubleshooting.md` | Debug guide | General OS kernel debugging decision system and failure classification. |

---

## Important Note

This repository is a reference stand.

Many files are intentionally incomplete, isolated, or experimental.

They are meant to be studied, adapted, and integrated into your own OSDev environment.

Do not expect all files to build together as one kernel.
