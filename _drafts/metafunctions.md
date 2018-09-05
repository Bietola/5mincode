## The useless personal introduction

This post shouldn't exist. The only thing that brought it into this unforgiving world is its writer's complete lack of summarization skills. This also happens to be the same particular type of incompetence that filled the writer's sad life with unfinished libraries and frameworks, preventing the fulfillment of his only one and true desire: a finished project.

Broken dreams aside (hard thing to do really...), like what happens when code is refactored out into a library, this post was made to be referred to when an explanation of the current formalities and underworkings of metafunctions (as of C++17, at least) is required.

Let me begin with claiming that I am no expert, and that I too have learned this from an assortment of books, talks and tutorials, of which I will try to refer to as hard as possible. The objective of this post is to take this assortment, turn into a somewhat logical "theory of metafunctions" and *bang*, offer it to the world.

So, let's begin!

## Giants and Shoulders

As promised, here's a list of resources you might also use for learning about metafuncitons (apart from this post, that is).

* [Modern C++ Design](https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design)  
  Considered by some the ante-litteram manifesto of TMP. That said, this is not really something you should read if you wanted to achieve anything practical... take it as a history lesson on how things used to be done back then, when TMP was still considered a (controversially) lucky accident. Still has some useful insights on policy-based design in and of itself.
* [Write Template Metaprogramming Expressively](https://www.fluentcpp.com/2017/06/02/write-template-metaprogramming-expressively/)  
  A nice case study on how to use TMP to implement contract-like capabilities (that is, in short, functions that check if certain types fit a given expression). Also covers some of the machinery behind metafunctions, *void_t*, and TMP in general.
* [Modern Template Metaprogramming, a Compendium](https://www.youtube.com/watch?v=Am2is2QCvxY)  
  A very complete cppcon talk by one of the fathers of C++ templates... what could you want more? For me, this was a more complete overview of what the above post refers to as *"low-level TMP"*. Also covers how the C++ standard evolved over the years to simplify certain TMP paradigms (such as typetraits), even though there is still much room for improvement (*read previous post for details*).
* [Practical C++ Metaprogramming](https://www.researchgate.net/publication/323994820_Practical_C_Metaprogramming)  
  A very deep, very recent, diehard dive into modern C++ metaprogramming (think encapsulating-variadic-parameter-packs-into-tuples kind of diehard), all while tackling practical problems. As I read this, I kept thinking about Alexandrescu's older book **Modern C++ Design** and the limitations that its author had to face back then. The two books try to implement similar tools, but what initially required esoteric hacks now seems to smoothly roll out of the standard library.
* [How to Make SFINAE Pretty](https://www.fluentcpp.com/2018/05/15/make-sfinae-pretty-1-what-value-sfinae-brings-to-code/)  
  Yes, another Fluent C++ post (I love that site, if you can't already tell). As it always is with Jonathan, the article is aimed at simplifying another abstruse C++ concept. It just happens to be that the topic treated is essential to TMP.

## How metafunctions work

In the beginning, there were functions. A **function** is a syntactic construct defined by a **name** and a **signature**. A signature is in turn composed of:

* A **return type**.
* A list of **parameters**.

Why am I telling you stuff you already know? Well, because that's exactly how a metafunction may also be defined. The only difference is the way these things are expressed in code and what they are allowed to be. Let's address these two points separately.

So, given a metafunction, where is the parameter list? Where's the return type? Well, here's a full-fledged metafunction:

``` cpp
template <int num>
struct plus_one {
    static const int value = num + 1;
};
```

And here's a full-fledged call to the same full-fledged metafunction:

``` cpp
int main() {
    std::cout << plus_one<1>::value << '\n';

    return 0;
}
```

Mere simplification can sometimes expose even the nastiest of paradigms. But in case it didn't suffice:

* The function only has one parameter: *num*, which is of type *int*. This, in technical terms, is called a **template parameter**.
* The function has a return value of *num + 1*, also of type *int*, named *value*.

Wait, a *named* return value? Well yes... that's how it is with metafunctions (at least for now). And naming it *value* - along with *type* for, well, types (see example below) - is a common convention. Common enough to be ubiquitous throughout the standard library.

## Types as values

What's been dealt with so far is not that much interesting. What's the difference in using a metafunction if it only lets us do mundane things like summing integers?

First of all, it sounds way cooler.

Perhaps a less important feature, metafunctions can handle types as if they were values. Take for instance this useless example:

``` cpp
typename std::remove_pointer<int*>::type x = 10;

std::cout << "x is an int of value " << x << std::endl;
```

Again, don't be scared by the gnarly syntax. Here's all that's happening: the *std::remove_pointer* function takes in a **type** (*int\**) and returns another, different **type** (*int*). The *typename* keyword is just there to help the compiler figure out that we intend to return is indeed a **type**, which is exactly what we do for "assigning" *int* to x.

How is *std::remove_pointer* implemented? Like this:

``` cpp
template <class T> struct remote_pointer     { using type = T; }
template <class T> struct remote_pointer<T*> { using type = T; }
```

Wait a second, why is there an extra set of angle brackets!? That's because of template specialization, another essential tool in the template metaprogramming toolbox. It works by enabling the programmer to specify specific **patterns** against which the received template parameters are matched. The more specific, the better. The non-specialized version is kept as a fall back in case the others fail.

In this case, if the *std::remove_pointer* function receives *int\** as a template parameter, the specialized version of the function template kicks in, as *int\** is successfully matched against *T\**, (*T* being *int*, in this case).

To give another example, here is the full implementation of *std::remove_pointer*, taken from the cppreference website:

``` cpp
template <class T> struct remove_pointer                    { using type = T };
template <class T> struct remove_pointer<T*>                { using type = T };
template <class T> struct remove_pointer<T* const>          { using type = T };
template <class T> struct remove_pointer<T* volatile>       { using type = T };
template <class T> struct remove_pointer<T* const volatile> { using type = T };
```

As you can see, the same technique is applied to handle more subtle edge cases. For instance, now a *const* *int** will gladly be accepted by the function and transformed into an *int* (deduced as the value of *T*).

But removing qualifiers from types is only the tip of the type manipulation iceberg. Take for instance this jewel of type manipulation, *std::decay* (also stolen from cppreference):

``` cpp
template< class T >
struct decay {
private:
    typedef typename std::remove_reference<T>::type U;
public:
    typedef typename std::conditional< 
        std::is_array<U>::value,
        typename std::remove_extent<U>::type*,
        typename std::conditional< 
            std::is_function<U>::value,
            typename std::add_pointer<U>::type,
            typename std::remove_cv<U>::type
        >::type
    >::type type;
};
```

Isn't it wonderful? Unfortunately, a full explanation is way out the scope of this post, but I figure that showing it might ignite a passion for type manipulation among readers.
<h2>Making metafunctions more readable</h2>
Inspirational code aside, let's look at another classic type manipulation classic (or rather, type manipulation helper) function:

``` cpp
template <class T, class = void>
struct is_asset : std::false_type {};

template <class T>
struct is_asset<T,
    std::void_t<decltype(
        std::declval<T>().loadFromFile(std::declval<const char*>())
    )>
> : std::true_type {};
```

This particular function is used, quite intuitively, to check if two given types are the same. The first *struct* represents a metafuction that takes two **template parameters** and always return false... or at least it looks like false.

Wait what the hell is a *std::false_type*? Well that's just the modern way to specify a metafunction return type! It does pile another level of abstraction on top, but nothing impossible to understand.

To understand *std::false_type* (and *std::true_type* for that manner) you must first understand *std::integral_constant*, which, in turn, is just an additional level of abstraction to represent compile time constants.

Remember that *static constexpr int value* that we had to type in to define a metafunction return type? Well it gets kind of repetitive after a while, so the guys at the STL came up with this little struct:

``` cpp
template <class T, T v>
struct integral_constant {
    static constexpr T value = v;
    constexpr operator T() const noexcept {return value;}
    // other useful stuff...
};
```

Which can be used like so:

``` cpp
template <int n>
struct plus_one :
    std::integral_constant<int, n + 1> {};
    ```

As you can see, *std::integral_constant* is just a fancy way of specifying a metafunction return type. Of course it's not just that, as it certainly has other features and uses. For our purposes, though, that's all we need.

As for *std::true_type*, well that's even easier! Possible implementation (also showing off *std::false_type*):

``` cpp
using true_type  = std::integral_constant<bool, true>;
using false_type = std::integral_constant<bool, false>;
```

And possible use (also example of using patter matching for recognizing non-type template parameters):

``` cpp
template <int n>
struct is_zero : std::false_type {};

template <>
struct is_zero<0> : std::true_type {};
```

So as you can see, just aliases. That's all there is to it. With their power, we can write more expressive metafunctions without being preoccupied with naming the return type (and who does that anyways). All so that we can write something like the snippet above instead of this:

``` cpp
template <int n>
struct is_zero {
    static constexpr bool value = false;
};

template <>
struct is_zero<0> {
    static constexpr bool value = true;
};
```

[TODO: turn following explanation of type templates from void_t to is_same_v. Also add a \_t example. Also modify example of is_same above to include a type alias declaration and function invocation example.]

All right, that's out of the way... but what about that call to *std::void_t*? It looks weird for a number of reasons, most prominent of the which might be the *_t* sticking out the back. Let's address that next.

So, sometimes, out in the wild, instead of seeing this:

``` cpp
typename std::remove_pointer<int*>::type x = 5;
```

You see this:

``` cpp
std::remove_pointer_t<int*> x = 10;
```

This is just a little bit of C++14 syntactic sugar at work. *std::remove_pointer_t* is still a **metafunction call**, but this handy alias...

``` cpp
template <class T>
using remove_pointer_t = typename remove_pointer<T>::type;
```

...called an **alias template**, saves us the chore of accessing the *::type* alias every time we use a metafunction. And as *_t* works for **types**, *_v* works for **values**:

``` cpp
template <typename T>
bool is_zero_v = is_zero<T>::value;
```

Pretty self explanatory. All using the all-new exclusive C++14 feature of **variable templates**. So that templates may keep subtly invading the language, one syntactic construct at a time.

Ok, let's have a look at that hideous thing one last time:

``` cpp

```

Congratulations, you can now write your own metafunctions! Granted I haven't actually given an in-depth explanation of any practical example. But remember that this is not what this post was about.
