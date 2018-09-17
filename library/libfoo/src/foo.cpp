#include <bar.hpp>
#include "foo.h"

std::string get_message() {
    return "Hello " + get_world();
}