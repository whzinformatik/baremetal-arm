#include <array>
#include <cstdint>
#include "span.hpp"

volatile auto const uart0 = reinterpret_cast<uint8_t* const>(0x10009000);

void write(const char* str)
{
	while (*str) {
		*uart0 = *str++;
	}
}

template<std::size_t N>
void write(tcb::span<const char, N> s)
{
	for(const auto c : s) {
		*uart0 = c;
	}
}

int main() {
	const char* s = "Hello world from bare-metal!\n";
	write(s);

	auto s2 = tcb::make_span("Hello C++\n");
	write(s2);

	std::array s3 = { 'A', 'B', 'C', '\n' };
	for(const auto c : s3) {
		*uart0 = c;
	}

	while (1) {};

	return 0;
}
