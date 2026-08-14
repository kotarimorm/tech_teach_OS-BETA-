# tech_teach_OS

> A practical OSDev survival kit for when your kernel breaks at 3 AM.

Small, focused NASM/x86 references for debugging and understanding low-level operating-system code.

This repository is not a complete operating system, bootable kernel, or production framework. It is a collection of independent examples, debugging guides, and hardware experiments.

## Start Here When Something Breaks

Take a breath. Do not change five things at once.

| Symptom | Start here |
|---|---|
| Kernel instantly reboots | [`debug/triple_fault.md`](debug/triple_fault.md) |
| Kernel freezes after `sti` | [`debug/troubleshooting.md`](debug/troubleshooting.md) |
| Crash after enabling paging | [`cpu/paging.asm`](cpu/paging.asm) |
| Keyboard IRQ does nothing | [`drivers/keyboard/keyboard.asm`](drivers/keyboard/keyboard.asm) |
| Timer interrupts never arrive | [`cpu/timer.asm`](cpu/timer.asm) |
| ATA read hangs | [`drivers/disk/ATA.asm`](drivers/disk/ATA.asm) |
| VGA output is corrupted | [`drivers/vga.asm`](drivers/vga.asm) |
| You do not know where to begin | [`MAP.md`](MAP.md) |

## First 60 Seconds

Before modifying the kernel:

1. Disable automatic reboot.
2. capture the QEMU command and log;
3. record the last known-good output;
4. identify the last initialized subsystem;
5. reproduce the failure twice;
6. change only one variable at a time.

Example diagnostic launch:

```sh
qemu-system-i386 \
  -drive format=raw,file=os.img \
  -no-reboot \
  -no-shutdown \
  -d int,cpu_reset,guest_errors \
  -D qemu.log
```

For GDB:

```sh
qemu-system-i386 -drive format=raw,file=os.img -s -S
gdb
```

Then:

```gdb
target remote localhost:1234
info registers
x/10i $eip
x/32wx $esp
```

## What You Will Find Here

- GDT and protected-mode setup
- IDT and interrupt gates
- PIC remapping
- ISR patterns
- PIT timer configuration
- identity paging
- physical-memory allocation experiments
- VGA text output
- PS/2 keyboard input
- ATA PIO access
- PCI discovery
- scheduler experiments
- panic helpers
- triple-fault diagnostics

## Repository Map

```text
cpu/          CPU state, paging, memory and timer examples
interrupts/   IDT, ISR and PIC references
drivers/      VGA, keyboard, ATA, PCI and driver experiments
kernel/       Panic and scheduling concepts
lib/          Small memory and printing helpers
debug/        Symptom-driven troubleshooting guides
```

See [`MAP.md`](MAP.md) for navigation by topic and failure symptom.

## How to Read a Snippet

Every example should be treated as a reference, not copied blindly.

Before using one, verify:

- CPU mode and architecture;
- required GDT selectors;
- expected memory mappings;
- initialized hardware;
- input registers;
- output registers;
- clobbered registers and flags;
- external symbols;
- interrupt state;
- failure and timeout behavior.

If one of those contracts is unclear, assume integration is unsafe until verified.

## Safety Levels

Examples currently use the following maturity levels:

| Level | Meaning |
|---|---|
| Reference | Focused example of one mechanism |
| Utility | Small reusable helper with documented assumptions |
| Experimental | Incomplete design requiring integration work |
| Unsafe demo | Educational code that must not be used unchanged |
| Stub | Placeholder without a complete implementation |

The status of every file is documented in [`MAP.md`](MAP.md).

## Important Assumptions

Most assembly examples target:

- 32-bit x86;
- NASM syntax;
- protected mode;
- ring 0;
- flat kernel segments;
- legacy hardware or emulated devices;
- QEMU-based experimentation.

They do not automatically account for:

- long mode;
- SMP;
- APIC;
- UEFI boot;
- userspace transitions;
- production-grade synchronization;
- every physical hardware implementation.

## Golden Debugging Rule

Preserve evidence before attempting a fix.

A useful investigation should answer:

1. What exactly failed?
2. At which initialization stage?
3. Which exception or IRQ occurred?
4. What were `EIP`, `ESP`, `EFLAGS`, `CR2`, and `CR3`?
5. Was the IDT valid?
6. Was the current stack mapped and writable?
7. What changed immediately before the failure?
8. How will the fix be verified?

## Project Philosophy

One concept.

One file.

One thing to understand.

No hidden framework and no unnecessary abstractions.

The repository should explain not only what working code looks like, but also:

- how it fails;
- what the failure looks like;
- how to collect evidence;
- how to fix it safely;
- how to prove the fix worked.

## Current Status

**BETA**

The repository already contains useful references, but some examples remain incomplete or unsafe.

Current limitations include:

- no unified build system;
- no automated assembly checks;
- no QEMU smoke-test suite;
- incomplete interrupt diagnostics;
- incomplete timeout handling;
- examples with external integration requirements.

Warnings and TODO comments are part of the documentation. Do not remove them without addressing the underlying limitation.

## Roadmap

The path toward a trusted OSDev reference:

- assemble every snippet automatically;
- document exports, inputs, outputs and clobbers;
- add timeout behavior to hardware polling;
- add serial and panic diagnostics;
- provide runnable failure laboratories;
- test examples in QEMU;
- publish expected output for every lab;
- add symptom-driven runbooks;
- keep unsafe examples clearly labelled.

## Contributing

A useful contribution should improve at least one of these:

- correctness;
- reproducibility;
- observability;
- failure handling;
- explanation quality;
- verification.

When changing a snippet, include:

1. the problem being solved;
2. required assumptions;
3. registers and flags affected;
4. expected behavior;
5. known failure modes;
6. a reproducible verification procedure.

## What This Repository Is Not

This repository is not:

- a finished operating system;
- a drop-in kernel library;
- a universal hardware abstraction layer;
- a replacement for processor or device documentation;
- proof that a snippet is safe on real hardware.

Test in an emulator before experimenting on physical hardware.

## The Promise

When your kernel explodes at 3 AM, this repository should help you:

- remain calm;
- preserve evidence;
- identify the failing layer;
- understand why it failed;
- apply one deliberate fix;
- verify that the failure is gone.

If it saves someone from losing two hours to a triple fault, it is doing its job.
