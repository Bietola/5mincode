#include <iostream>
#include <string_view>

template <class T>
constexpr std::string_view type_name() {
    using namespace std;
#ifdef __clang__
    string_view p = __PRETTY_FUNCTION__;
    return string_view(p.data() + 34, p.size() - 34 - 1);
#elif defined(__GNUC__)
    string_view p = __PRETTY_FUNCTION__;
#  if __cplusplus < 201402
    return string_view(p.data() + 36, p.size() - 36 - 1);
#  else
    return string_view(p.data() + 49, p.find(';', 49) - 49);
#  endif
#elif defined(_MSC_VER)
    string_view p = __FUNCSIG__;
    return string_view(p.data() + 84, p.size() - 84 - 7);
#endif
}

template <class T>
struct type_of {
    using type = T;
};

template <class T>
struct remove_const : type_of<T> {};

template <class T>
using remove_const_t = typename remove_const<T>::type;

template <class T>
struct remove_volatile : type_of<T> {};

template <class T>
using remove_volatile_t = typename remove_volatile<T>::type;

template <class T>
using remove_cv_t = remove_volatile_t<remove_const_t<T>>;

template <class T>
struct remove_pointer : type_of<T> {};

int main() {
    std::cout << type_name<remove_cv_t<int const volatile>> << "\n";
    
    return 0;
}
