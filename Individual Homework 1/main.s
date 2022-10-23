.intel_syntax noprefix
	.text                             # Начинает секцию.
	.local	A			              # Объявляем символ A, но не экспортируем его
	.comm	A,4194304,32              # Неинициализированный массив в нём 1048576 * 4 байт
	.local	B			              # Объявляем символ B, но не экспортируем его
	.comm	B,4194304,32              # Неинициализированный массив в нём 1048576 * 4 байт
	.section	.rodata               # Переходим в секцию .rodata (readonly)
.LC0:					              # .LCO: "%d"
	.string	"%d"
	.text				              # Секция с кодом.
	.globl	fill_array                # Объявляем и экспортируем вовне символ `fill_array`
	.type	fill_array, @function     # Отмечаем, что fill_array это функция
fill_array:				              # Начинается функция заполнения массива
	push	rbp                     # / Пролог функции (1/3). Сохранили предыдущий rbp на стек
	mov	rbp, rsp                    # | Пролог функции (2/3). Вместо rbp записали rsp.
	sub	rsp, 32                     # \ Пролог функции (3/3). А сам rsp сдвинули на 32 байтa
	mov	DWORD PTR -20[rbp], edi	      # rbp[-20] := edi
	mov	r12d, 0	                      # r12d := 0
	jmp	.L2                           # Переход к метке .L2
.L3:
	mov	eax, r12d                     # eax := r12d
	cdqe   # Convert Doubleword to Qwadword — у нас был eax, стал нормальный rax, делает sign-extend
	lea	rdx, 0[0+rax*4]   # rdx := rax * 4 вычисляет адрес (rax*4)[0], который равен rax*4
	lea	rax, A[rip]		  # rax := &rip[A]
	add	rax, rdx          # rax += rdx
	mov	rsi, rax		  # rsi := rax - 2-й аргумент
	lea	rdi, .LC0[rip]    # rdi := &rip[.LCO]
	mov	eax, 0            # eax := 0
	call	__isoc99_scanf@PLT       # scanf("%d", &rbp[-12])
	add	r12d, 1           # r12d += 1
.L2:
	mov	eax, r12d         # eax := r12d
	cmp	eax, DWORD PTR -20[rbp]     # сравнить eax и rbp[-20] (это счетчик цикла и N)
	jl	.L3               # если выполняется условие, то перейти к .L3: (иначе выйти из цикла)
	nop
	nop
	leave                  # / Эпилог (1/2) 
	ret                    # \ Эпилог (2/2) конец кода функции fill_array
	.size	fill_array, .-fill_array
	.globl	print_result
	.type	print_result, @function
print_result:
	endbr64
	push	rbp                     # / Пролог функции (1/3). Сохранили предыдущий rbp на стек
	mov	rbp, rsp                    # | Пролог функции (2/3). Вместо rbp записали rsp
	sub	rsp, 32                     # \ Пролог функции (3/3). А сам rsp сдвинули на 32 байтa
	mov	DWORD PTR -20[rbp], edi     # rbp[-20] := edi
	mov	r12d, 0	                    # r12d = 0
	jmp	.L5                         # Переход к метке .L5
.L6:
	mov	eax, r12d                   # eax := r12d
	cdqe
	lea	rdx, 0[0+rax*4]             # rdx := rax * 4
	lea	rax, B[rip]                 # rax := &rip[B]
	mov	esi, DWORD PTR [rdx+rax]    # esi := *(rdx + rax)
	lea	rdi, .LC0[rip]              # rdi := &rip[.LCO]
	mov	eax, 0                      # eax := 0
	call	printf@PLT              # вызов printf
	add	r12d, 1                     # r12d += 1
.L5:
	mov	eax, r12d                   # eax := r12d
	cmp	eax, DWORD PTR -20[rbp]     # сравнить eax и rbp[-20] (это счетчик цикла и N)    
	jl	.L6     # если выполняется условие, то перейти к .L6: (иначе выйти из цикла)
	nop
	nop
	leave                           # / Эпилог (1/2) 
	ret                             # \ Эпилог (2/2) конец кода функции print_result
	.size	print_result, .-print_result
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp                     # / Пролог функции (1/3). Сохранили предыдущий rbp на стек
	mov	rbp, rsp                    # | Пролог функции (2/3). Вместо rbp записали rsp.
	sub	rsp, 32                     # \ Пролог функции (3/3). А сам rsp сдвинули на 32 байтa
	mov	DWORD PTR -20[rbp], edi     # rbp[-20] := edi — это первый аргумент, `argc` (rdi)
	mov	QWORD PTR -32[rbp], rsi     # rbp[-32] := rsi — это второй аргумент, `argv` (rsi)
	mov	DWORD PTR -8[rbp], 0	    # rbp[-8] := 0
	mov	DWORD PTR -12[rbp], 0	    # rbp[-12] := 0
	lea	rax, -16[rbp]		        # rax := &(-16 на стеке)
	mov	rsi, rax		            # rsi := rax
	lea	rdi, .LC0[rip]		        # rdi := &rip[.LCO]
	mov	eax, 0                      # eax := 0
	call	__isoc99_scanf@PLT	    # scanf("%d", &rbp[-12])
	mov	eax, DWORD PTR -16[rbp]     # eax := rbp[-16]
	mov	edi, eax                    # edi := eax
	call	fill_array              # вызов функции fill_array
	mov	r12d, 0                     # r12d := 0
	mov r13d, -12[rbp]              # загружаем n в регистр r13d
	
	jmp	.L8                        # Переход к метке .L8
.L11:
	mov	eax, r12d                  # eax := r12d
	cdqe
	lea	rdx, 0[0+rax*4]            # rdx := rax * 4
	lea	rax, A[rip]                # rax := &rip[A]
	mov	eax, DWORD PTR [rdx+rax]   # eax := *(rdx + rax)
	test	eax, eax
	js	.L9
	mov	eax, r12d                  # eax := r12d
	cdqe
	lea	rdx, 0[0+rax*4]            # rdx := rax * 4
	lea	rax, A[rip]                # rax := &rip[A]
	mov	eax, DWORD PTR [rdx+rax]   # eax := *(rdx + rax)
	add	DWORD PTR -8[rbp], eax     # rbp[-8] += eax
	jmp	.L10                       # Переход к метке .L10
.L9:
	mov	eax, r12d                  # eax := r12d
	cdqe
	lea	rdx, 0[0+rax*4]            # rdx := rax * 4
	lea	rax, A[rip]                # rax := rip[A] — наша строка "%d"
	mov	eax, DWORD PTR [rdx+rax]   # eax := *(rdx + rax)
	add	r13d, eax                  # r13d += eax
.L10:
	add	r12d, 1                    # r12d += 1
.L8:
	mov	eax, DWORD PTR -16[rbp]    # eax := rbp[-16]
	cmp	r12d, eax                  # сравнить r12d и eax
	jl	.L11    # если выполняется условие, то перейти к .L11: (иначе выйти из цикла)
	mov	r12d, 0        # r12d := 0
	jmp	.L12           # Переход к метке .L12
.L15:
	mov	eax, r12d      # eax := r12d
	and	eax, 1
	test	eax, eax
	jne	.L13
	mov	eax, r12d               # eax := rbp[-16]
	cdqe
	lea	rcx, 0[0+rax*4]         # rcx := rax * 4
	lea	rdx, B[rip]             # rdx := &rip[B] — адрес начала массива
	mov	eax, DWORD PTR -8[rbp]        # eax := rbp[-8]
	mov	DWORD PTR [rcx+rdx], eax      # [rcx + rdx] := eax — наконец, записать в rdx[rcx] := eax
	jmp	.L14                          # Переход к метке .L14
.L13:
	mov	eax, r12d             # eax := r12d
	cdqe
	lea	rcx, 0[0+rax*4]       # rcx := rax * 4
	lea	rdx, B[rip]           # rdx := &rip[B] — адрес начала массива
	mov	eax, r13d             # eax := r13d
	mov	DWORD PTR [rcx+rdx], eax    # [rcx + rdx] := eax — наконец, записать в rdx[rcx] := eax
.L14:
	add	r12d, 1                     # r12d += 1
.L12:
	mov	eax, DWORD PTR -16[rbp]     # eax := rbp[-16]
	cmp	r12d, eax                   # сравнить r12d и eax
	jl	.L15        # если выполняется условие, то перейти к .L3: (иначе выйти из цикла)
	mov	eax, DWORD PTR -16[rbp]     # eax := rbp[-16]
	mov	edi, eax                    # edi := eax
	call	print_result            # вызов функции print_result
	mov	eax, 0                      # eax := 0
	leave                           # / Эпилог (1/2)
	ret                             # \ Эпилог (2/2)
