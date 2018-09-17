#include <iostream>
#include <foo.h>
#include <bar.hpp>

int main(int argc, char **argv) {
    std::cout << get_name() << ": " << get_message() << std::endl;
    return 0;
}
