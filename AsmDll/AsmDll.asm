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

    ;wszystkie poni�sze instrukcje, a� do nast�pnej etykiety s�, aby przygotowa� dane w odpowiedni spos�b, pierwsze 4 wsp�czynniki s� 0
    ;wi�c mno�ymy i dodajemy tak, aby pierwszy wsp�czynnik zaczyna� si� mno�y� od ostatniego double w rejestrze ymm (to dzieje si� od nast�pnej etykiety)
    ;a poni�sze instrukcje s� niejako przygotowaniem danych do tego
    vpxor ymm12, ymm12, ymm12 ;czyszczenie rejestru ymm
    vpxor ymm13, ymm13, ymm13 ;czyszczenie rejestru ymm
    vpxor ymm14, ymm14, ymm14 ;czyszczenie rejestru ymm
    vpxor ymm15, ymm15, ymm15 ;czyszczenie rejestru ymm
    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm

    vmovupd ymm0, [r9] ;bierzemy pierwsze 4 double z pr�bek
    vmovupd ymm2, [r9+32] ;nast�pne 4 double
    vmovupd ymm3, [r9+64] ;kolejne 4 double
    vmovupd ymm4, [r9+96] ;kolejne 4 double
    vmovupd ymm1, [r8 + 8 + r14] ;oraz 4 wsp�czynniki (pomijaj�c pierwszy), trzy z nich s� 0, a ostatni to nasz prawdziwy wsp�czynnik posiadaj�cy warto��
    vmulpd ymm8, ymm0, ymm1 
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;wymna�amy wektorowo wszystkie posiadane pr�bki ze wsp�czynnikami, wi�c jedynie ostatni element, tutaj indeks 3, 7, 11 i 15 b�d� mia�y warto��, bo reszta wsp�czynnik�w to 0
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wynik w innych rejestrach

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm


    vmovupd ymm1, [r8 + 16 + r14] ;nast�pnie przesuwamy wsp�czynniki
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;mno�ymy ponownie, a wi�c indeksy wskazane w linii 40 b�d� si� ju� mno�y� przez 2 wsp�czynnik, a 1 przesunie nam si� na 2,6,10 i 14 indeks
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;ponownie zapisujemy wynik do tych samych rejestr�w (w dw�ch nadal nic si� nie dzieje)

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm


    vmovupd ymm1, [r8 + 24 + r14] ;ponawiamy przesuni�cie wsp�czynnik�w
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1
    vmulpd ymm11, ymm4, ymm1 ;mno�ymy ponownie, teraz 1 wsp�czynnik jest na 1,6,9 i 13 indeksie
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wynik ostatni raz (pierwszy indeks, czyli 0,4,8 i 12 nadal pozostaje nieruszony)

    add r14, 32 ;dodajemy fo r14, tak aby zaczyna�o mno�y� 1 indeks 1 wsp�czynnik i zaczynamy w�a�ciw� p�tle

NEW_VALUE:

    vpxor ymm8, ymm8, ymm8 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm9, ymm9, ymm9 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm10, ymm10, ymm10 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm
    vpxor ymm11, ymm11, ymm11 ;czyszczenie rejestru ymm ;czyszczenie rejestru ymm

    vmovupd ymm0, [r9 + r14]
    vmovupd ymm2, [r9 + 32 + r14]
    vmovupd ymm3, [r9 + 64 + r14]
    vmovupd ymm4, [r9 + 96 + r14]
    vmovupd ymm1, [r8 + 32 + r14] ;wymna�amy tak samo jak powy�ej, z tym �e teraz wiemy, �e wy�sze indeksy by�y ju� wymno�one przez ni�sze wsp�czynniki, wi�c nie musimy ju� si� o to martwi�
    vmulpd ymm8, ymm0, ymm1
    vmulpd ymm9, ymm2, ymm1
    vmulpd ymm10, ymm3, ymm1 
    vmulpd ymm11, ymm4, ymm1 ;mno�ymy wektorowo
    vaddpd ymm12, ymm8, ymm12
    vaddpd ymm13, ymm9, ymm13
    vaddpd ymm14, ymm10, ymm14
    vaddpd ymm15, ymm11, ymm15 ;zapisujemy wyniki
    
    add r14, 8 ;przesuwamy si� o 1 wsp�czynnik
    cmp r14, 1624 ;sprawdzamy czy wszystkie wspolczynniki zostaly wymnozone
    jl NEW_VALUE
    vmovupd [rcx], ymm12 ;zapisujemy do wynikowej tablicy wszystkie 16 zmiennych double
    vmovupd [rcx+32], ymm13
    vmovupd [rcx+64], ymm14
    vmovupd [rcx+96], ymm15

    jmp INNER_LOOP_EXIT ;wychodzimy z p�tli
procData endp
end