#include <config/config.h>
#ifdef CONFIG_ARCH_AARCH64
#define PTR .quad
#define ALGN .align 8
#else
#define PTR .long
#define ALGN .align 4
#endif

.section .__symbols__, "a"
        PTR        allsyms_addresses
        PTR        allsyms_num_syms
        PTR        allsyms_offset
        PTR        allsyms_names

.section .rodata, "a"
.global allsyms_addresses
        ALGN
allsyms_addresses:
.global allsyms_num_syms
        ALGN
allsyms_num_syms:
        .long    0x0

.global allsyms_offset
        ALGN
allsyms_offset:
.global allsyms_names
        ALGN
allsyms_names:
