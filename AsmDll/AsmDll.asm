.code
procData proc
    mov r12, rdx ; liczba elementow do przetworzenia 
    mov rdi, [rsp + 40] ; indeks poczatkowy
    add r9, rdi ;dodatnie indeksu poczatkowego do rejestru r9, w ktorym jest wskaznik na tabele probek
    
MAIN_LOOP:
    jmp INNER_LOOP ;skok do wewnetrznej petli
INNER_LOOP_EXIT:
    add rcx, 128 ;dodajemy przeprocesowane 16 zmiennych double
    add r9, 128 ;tutaj rowniez
    sub r12, 16 ;odejmujemy od pozostalych elementow do przetworzenia
    cmp r12, 0 ;sprawdzamy czy elementy nam sie nie skonczyly
    jg MAIN_LOOP ;jesli nie to powtarzamy
    ret ;jesli tak to konczymy program
INNER_LOOP: 
    xor r14, r14 ;czyszczenie rejestru
    xor r13, r13 ;czyszczenie rejestru

    ;wszystkie poni¿sze instrukcje, a¿ do nastêpnej etykiety s¹, aby przygotowaæ dane w odpowiedni sposób, pierwsze 4 wspó³czynniki s¹ 0
    ;wiêc mno¿ymy i dodajemy tak, aby pierwszy wspó³czynnik zaczyna³ siê mno¿yæ od ostatniego double w rejestrze ymm (to dzieje siê od nastêpnej etykiety)
    ;a poni¿sze instrukcje s¹ niejako przygotowaniem danych do tego
    vpxor ymm12, ymm12, ymm12 ;czyszczenie rejestru ymm
    vpxor ymm13, ymm13, ymm13 ;czyszczenie rejestru ymm
    vpxor ymm14, ymm14, ymm14 ;czyszczenie rejestru ymm
    vpxor ymm15, ymm15, ymm15 ;czyszczenie rejestru ymm
    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm

    vmovupd ymm0, [r9] ;bierzemy pierwsze 4 double z próbek
    vmovupd ymm2, [r9+32] ;nastêpne 4 double
    vmovupd ymm3, [r9+64] ;kolejne 4 double
    vmovupd ymm4, [r9+96] ;kolejne 4 double
    vmovupd ymm1, [r8 + 8 + r14] ;oraz 4 wspó³czynniki (pomijaj¹c pierwszy), trzy z nich s¹ 0, a ostatni to nasz prawdziwy wspó³czynnik posiadaj¹cy wartoœæ
    vmulpd ymm8, ymm0, ymm1 
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;wymna¿amy wektorowo wszystkie posiadane próbki ze wspó³czynnikami, wiêc jedynie ostatni element, tutaj indeks 3, 7, 11 i 15 bêd¹ mia³y wartoœæ, bo reszta wspó³czynników to 0
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wynik w innych rejestrach

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm


    vmovupd ymm1, [r8 + 16 + r14] ;nastêpnie przesuwamy wspó³czynniki
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;mno¿ymy ponownie, a wiêc indeksy wskazane w linii 40 bêd¹ siê ju¿ mno¿yæ przez 2 wspó³czynnik, a 1 przesunie nam siê na 2,6,10 i 14 indeks
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;ponownie zapisujemy wynik do tych samych rejestrów (w dwóch nadal nic siê nie dzieje)

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm


    vmovupd ymm1, [r8 + 24 + r14] ;ponawiamy przesuniêcie wspó³czynników
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;mno¿ymy ponownie, teraz 1 wspó³czynnik jest na 1,6,9 i 13 indeksie
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wynik ostatni raz (pierwszy indeks, czyli 0,4,8 i 12 nadal pozostaje nieruszony)

    add r14, 32 ;dodajemy fo r14, tak aby zaczyna³o mno¿yæ 1 indeks 1 wspó³czynnik i zaczynamy w³aœciw¹ pêtle

NEW_VALUE:

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm

    vmovupd ymm0, [r9 + r14]
    vmovupd ymm2, [r9 + 32 + r14]
    vmovupd ymm3, [r9 + 64 + r14]
    vmovupd ymm4, [r9 + 96 + r14]
    vmovupd ymm1, [r8 + 32 + r14] ;wymna¿amy tak samo jak powy¿ej, z tym ¿e teraz wiemy, ¿e wy¿sze indeksy by³y ju¿ wymno¿one przez ni¿sze wspó³czynniki, wiêc nie musimy ju¿ siê o to martwiæ
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1 
    vmulpd ymm11, ymm4, ymm1 ;mno¿ymy wektorowo
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wyniki
    
    add r14, 8 ;przesuwamy siê o 1 wspó³czynnik
    cmp r14, 1624 ;sprawdzamy czy wszystkie wspolczynniki zostaly wymnozone
    jl NEW_VALUE
    vmovupd [rcx], ymm12 ;zapisujemy do wynikowej tablicy wszystkie 16 zmiennych double
    vmovupd [rcx+32], ymm13
    vmovupd [rcx+64], ymm14
    vmovupd [rcx+96], ymm15

    jmp INNER_LOOP_EXIT ;wychodzimy z pêtli
procData endp
end