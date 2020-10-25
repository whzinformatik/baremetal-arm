#include <cstdint>

volatile auto const uart0 = reinterpret_cast<uint8_t* const>(0x10009000);

void write(const char* str)
{
	while (*str) {
		*uart0 = *str++;
	}
}

#include <array>
#include "span.hpp"

int main() {
	const char* s = "Hello world from bare-metal!\n";
	write(s);
	std::array<char, 8> a = {'h' };
	auto s1 = tcb::make_span(a);
	auto s2 = tcb::make_span("Hello");
	*uart0 = 'A';
	*uart0 = 'B';
	*uart0 = 'C';
	*uart0 = '\n';
	while (*s != '\0') {
		*uart0 = *s;
		s++;
	}
	while (1) {};

	return 0;
}
