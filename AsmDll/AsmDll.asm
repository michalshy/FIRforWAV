.code
procData proc
    mov r12, rdx 
    mov rdi, [rsp + 40] 
    add r9, rdi
    
MAIN_LOOP:
    jmp INNER_LOOP
INNER_LOOP_EXIT:
    add rcx, 128
    add r9, 128 
    sub r12, 16
    cmp r12, 0 
    jg MAIN_LOOP 
    ret
INNER_LOOP: 
    xor r14, r14
    xor r13, r13 

    vpxor ymm12, ymm12, ymm12 
    vpxor ymm13, ymm13, ymm13 
    vpxor ymm14, ymm14, ymm14 
    vpxor ymm15, ymm15, ymm15
    vpxor ymm8, ymm8, ymm8
    vpxor ymm9, ymm9, ymm9 
    vpxor ymm10, ymm10, ymm10 
    vpxor ymm11, ymm11, ymm11

    vmovupd ymm0, [r9] 
    vmovupd ymm2, [r9+32]
    vmovupd ymm3, [r9+64]
    vmovupd ymm4, [r9+96]
    vmovupd ymm1, [r8 + 8 + r14]
    vmulpd ymm8, ymm0, ymm1 
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15

    vpxor ymm8, ymm8, ymm8 
    vpxor ymm9, ymm9, ymm9 
    vpxor ymm10, ymm10, ymm10 
    vpxor ymm11, ymm11, ymm11


    vmovupd ymm1, [r8 + 16 + r14]
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 

    vpxor ymm8, ymm8, ymm8 
    vpxor ymm9, ymm9, ymm9 
    vpxor ymm10, ymm10, ymm10
    vpxor ymm11, ymm11, ymm11 


    vmovupd ymm1, [r8 + 24 + r14] 
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15

    add r14, 32 

NEW_VALUE:

    vpxor ymm8, ymm8, ymm8 
    vpxor ymm9, ymm9, ymm9 
    vpxor ymm10, ymm10, ymm10
    vpxor ymm11, ymm11, ymm11 

    vmovupd ymm0, [r9 + r14]
    vmovupd ymm2, [r9 + 32 + r14]
    vmovupd ymm3, [r9 + 64 + r14]
    vmovupd ymm4, [r9 + 96 + r14]
    vmovupd ymm1, [r8 + 32 + r14] 
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1 
    vmulpd ymm11, ymm4, ymm1 
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 
    
    add r14, 8 
    cmp r14, 1624
    jl NEW_VALUE
    vmovupd [rcx], ymm12 
    vmovupd [rcx+32], ymm13
    vmovupd [rcx+64], ymm14
    vmovupd [rcx+96], ymm15

    jmp INNER_LOOP_EXIT 
procData endp
end