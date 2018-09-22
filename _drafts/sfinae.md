## SFINAE

So far, we've only defined metafunctions that either:

* Do things regular functions do (i.e. accept *values*, return *values*).
  is_zero, etc...
* Accept types and return types.
  remove_pointer, decay, etc...
* Do something in between.
  is_same, etc...

But what if I told you that values and types are not everything that a metafunction can work with? Consider the following (rather contentious) piece of code:

``` cpp
template <class T>
struct is_bool {};

// other suspicious code...

int main() {
    std::cout << std::boolalpha << is_bool<bool>::value << "\n";
    return 0;
}
```

If you show this innocent-looking snippet to a random guy out in the street, she would probably point out that it must have has an error. "There's no way this could ever compile!", would this hypothetical person say, "since the *is_bool* class template *does not* have a *::value* member."
Still this code compiles... and prints *true*.

You're probably now wondering what the *suspicious code* comment is all about. Well of course it's other template code! A template specialization, to be exact:

```cpp
#include <type_traits> // for std::true_type

template <class T>
struct is_bool {};

// the suspicious code
template <>
struct is_bool<bool> : std::true_type {}

int main() {
    std::cout << std::boolalpha << is_bool<bool>::value << "\n";
    return 0;
}
```

You might be starting to understand why this compiles. Put simply, the *is_bool<bool>* template specialization is picked by the compiler, since *is_bool<bool>* is exactly what is requrested at call site. And the *is_bool<bool>* **struct** actually has a *value* static member (if you're confused of why that is, you might want to read [the previous section](#Making-metafunctions-more-readable)).

But wait a second... is the compiler just going to ignore that *is_bool<T>::value* isn't going to compile with literally any other *T*? Well, yes. As it [the compiler] churns through code, it simply discards the *impossible to instantiate* class-template and go on trying with its specializations until it succeds.

This particular phenomena is called **SFINAE**: "Substitution Failure Is Not An Error".

Here **substitution** simply means "try to instantiate the class-template given a certain expression". To be as clear as possible, take our example: the compiler will first try to substitute is_bool<T>

```cpp
bool x = false;
is_bool_v<decltype(x)> // returns true
```

Congratulations, you can now write your own metafunctions! Granted I haven't actually given an in-depth explanation of any practical example. But remember that this is not what this post was about.
