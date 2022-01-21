#define _CRT_SECURE_NO_WARNINGS
#include<Windows.h>
#include<stdio.h>
int main() {
	HINSTANCE handle = LoadLibraryA("VictimDll.dll");
	FARPROC function = GetProcAddress(handle, "add");
	int a, b;
	printf("Please input two number a, b: ");
	scanf("%d%d", &a, &b);
	printf("Sum is: ");
	int (*func)(int, int) = function;
	printf("%d + %d = %d", a, b, func(a, b));
}