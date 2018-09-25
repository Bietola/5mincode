---
layout: post
image:
    path: /assets/show/astrowizard.png
    thumbnail: /assets/show/colorcubes.jpeg
    caption: "You shall not compile!"
author: dincio
---

## The useless personal introduction

This series of posts shouldn't exist. The only thing that brought it into this unforgiving world is its writer's complete lack of summarization skills. This also happens to be the same particular type of incompetence that filled the writer's sad life with unfinished libraries and frameworks, preventing the fulfillment of his only one and true desire: a finished project.


Broken dreams aside (hard thing to do really...), like what happens when code is refactored out into a library, these posts were made to be referred to when an explanation of the current formalities and underworkings of metafunctions (as of C++17, at least) is required.

Let me begin with claiming that I am no expert, and that I too have learned all of this from an assortment of books, talks and tutorials, of which I will try to refer to as hard as possible. My objective here is to take this assortment, turn into a somewhat logical "theory of metafunctions" and *bang*, offer it to the world to read. What could possibly go wrong?

So, let's begin!

## So much posts

As of now, here are the topics I would like to cover:

* **this post**: Understanding of metafunction syntax for compile-time value/type manipulation.
* **work in progress**: Manipulating something that is neither a type, nor a value: ~~*black magic*~~ *invalid state*, occasionally (but not exclusively) using the power of a C++ exclusive feature: *SFINAE*.
* **in the future**: Creating a rudimentary "*meta-stl*" with compile-time containers and algorithms.
* **in the future**: Study of already existing metafunction-based libraries.

## Giants and Shoulders

As promised, here's a list of resources you might also use for learning about metafunctions (apart from this post, that is).

* [Modern C++ Design](https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design)  
  Considered by some the ante-litteram manifesto of TMP. That said, this is not really something you should read if you want to achieve anything practical... take it as a history lesson on how things used to be done back then, when TMP was still considered a (controversially) lucky accident. Still has some useful insights on policy-based design (a programming style invented by the author) in and of itself.
* [Write Template Metaprogramming Expressively](https://www.fluentcpp.com/2017/06/02/write-template-metaprogramming-expressively/)  
  A nice case study on how to use TMP to implement contract-like capabilities (that is, in short, functions that check if certain types fit a given expression). Also covers some of the machinery behind metafunctions, *void_t*, and TMP in general.
* [Modern Template Metaprogramming, a Compendium](https://www.youtube.com/watch?v=Am2is2QCvxY)
  A very complete cppcon talk by one of the fathers of C++ templates. what could you want more? For me, this was a more complete overview of what the above post refers to as *"low-level TMP"*. Also covers how the C++ standard evolved over the years to simplify certain TMP paradigms (such as typetraits), even though there is still much room for improvement (*read previous post for details*).
* [Practical C++ Metaprogramming](https://www.researchgate.net/publication/323994820_Practical_C_Metaprogramming)  
  A very deep, very recent, diehard dive into modern C++ metaprogramming (think encapsulating-variadic-parameter-packs-into-tuples kind of diehard), all while tackling practical problems. As I read this, I kept thinking about Alexandrescu's older book **Modern C++ Design** and the limitations that its author had to face back then. The two books try to implement similar tools, but what initially required esoteric hacks now seems to smoothly roll out of the standard library.
* [How to Make SFINAE Pretty](https://www.fluentcpp.com/2018/05/15/make-sfinae-pretty-1-what-value-sfinae-brings-to-code/)  
  Yes, another **Fluent C++** post (I love that site, if you can't already tell). As it always is with Jonathan, the article is aimed at simplifying yet another abstruse C++ concept. It just happens to be that the topic treated is essential to TMP.
* [Your Own Type Predicate](https://akrzemi1.wordpress.com/2017/12/02/your-own-type-predicate/)  
  Admittedly a post that made me click about a lot of stuff, most prominently *SFINAE* and its relation to *void_t*'s required existence to implement contracts as of C++17. All in all a very pragmatic and eye-opening introduction to metafunctions and some of their uses. Also my go-to post when I need a review (apart from my own, of course).

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
plus_one<1>::value // returns 2
```

Mere simplification can sometimes expose even the nastiest of paradigms. But in case it didn't suffice:

* The function only has one parameter: *num*, which is of type *int*. This, in technical terms, is called a **template parameter**.

* The function has a return value of *num + 1*, also of type *int*, named *value*.

Wait, a *named* return value? Well yes... that's how it is with metafunctions (at least for now). And naming it *value* - along with *type* for, well, types (see example below) - is a common convention. Common enough to be ubiquitous throughout the standard library.

## Types as values

What's been dealt with so far might not be that much interesting. What's the difference in using a metafunction if it only lets us do mundane things like summing integers?

First of all, it sounds way cooler.

Perhaps a less important feature, metafunctions can handle types as if they were values. Take for instance this useless example:

``` cpp
typename std::remove_pointer<int*>::type x = 10;

std::cout << "x is an int of value " << x << std::endl;
```

Again, don't be scared by the gnarly syntax. Here's all that's happening: the *std::remove_pointer* function takes in a **type** (*int\**) and returns another, different **type** (*int*). The *typename* keyword is just there to help the compiler figure out that what we intend to return is indeed a **type**, which is exactly what we do for declaring x as an integer.

How is *std::remove_pointer* implemented? Like this:

``` cpp
template <class T> struct remove_pointer     { using type = T; }
template <class T> struct remove_pointer<T*> { using type = T; }
```

Wait a second, why is there an extra set of angle brackets!?

First of all, calm down.

Jeez.

Then realize that it's just because of template specialization, another essential tool in the template metaprogramming toolbox. It works by enabling the programmer to specify specific **patterns** against which the received template parameters are matched. The more specific, the better. The non-specialized version is kept as a fallback in case the others fail.

In our case, if the *std::remove_pointer* function receives *int\** as a template parameter, the specialized version of the function template kicks in, as *int\** is successfully matched against *T\**, (*T* being recognized as *int*, in this case).

To give another example, here is the full implementation of *std::remove_pointer*, taken from the cppreference website:

``` cpp
template <class T> struct remove_pointer                    { using type = T };
template <class T> struct remove_pointer<T*>                { using type = T };
template <class T> struct remove_pointer<T* const>          { using type = T };
template <class T> struct remove_pointer<T* volatile>       { using type = T };
template <class T> struct remove_pointer<T* const volatile> { using type = T };
```

As you can see, the same technique is applied to handle more subtle edge cases. For instance, now a *int\* const* will gladly be accepted by the specialization and transformed into an *int* (deduced as the value of *T* from the *T\* const* pattern).

But removing qualifiers from types is only the tip of the type manipulation iceberg.
Take for instance this jewel of type manipulation, *std::decay* (also stolen from cppreference):

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

Isn't it wonderful? Unfortunately, a full explanation is way out of the scope of this post, but I figure that showing it might ignite a passion for type manipulation among readers.

<a id="Making-metafunctions-more-readable"></a>
## Making metafunctions more readable

Inspirational code aside, let's look at another classic type manipulation - or rather, type manipulation helper - function:

<a id="is_same-def"></a>
```cpp
template <class T, class U>
struct is_same : std::false_type {};

template <class T>
struct is_same<T, T> : std::true_type {};
```

This particular function is used, quite intuitively, to check if two given types are the same. The first *struct* represents a metafuction that takes two **template parameters** and always returns false... or at least it looks like false.

Wait, what the hell is a *std::false_type*? Well that's just the modern way to specify a metafunction return type! It does pile another level of abstraction on top, but nothing impossible to understand.

To understand *std::false_type* (and *std::true_type*, for that manner) you must first understand *std::integral_constant*, which, in turn, is just an additional level of abstraction to represent compile time constants.

Remember that *static constexpr int value* that we had to type in to define a metafunction return type? Well it gets kind of repetitive after a while, so much so that the guys at the STL came up with this little struct:

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

As you can see, *std::integral_constant* is just a fancy way of specifying a metafunction return type. Of course it's not just that, as it certainly has other features and uses. For our purposes, though, that's all we need it for.

As for *std::true_type*, well that's even easier! Possible implementation (also showing off *std::false_type*):

``` cpp
using true_type  = std::integral_constant<bool, true>;
using false_type = std::integral_constant<bool, false>;
```

And possible use (also example of using pattern matching for recognizing non-type template parameters):

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

All right, that's out of the way. We can now effortlessly test our is_same function. Let's use the one kindly offered to us by the **C++ standard library**:

```cpp
std::is_same<int, int>; // should return true...
```

And of course the above program outputs *true*:

```
error: expected primary-expression before '<<' token
```

Wait what?

Oh yes, we forgot to retrieve the value! Remember that *std::is_same* is just [a templated struct wrapping the result of our operation](#is_same-def), which we need to access explicitly.

```cpp
std::is_same<int, int>::value // returns true
```

This is a bit redundant though. After all, did you ever need to specify that you needed the return value of a function upon calling it?

``` cpp
int x = f("hello")::return_value;
```

Not really... or at least this is what the standard committee thought. So, sometimes, out in the wild, instead of seeing this:

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
template <typename T, typename U>
inline constexpr bool is_same_v = is_same<T, U>::value;
```

Pretty self explanatory. All using the new C++17 shiny feature of **variable templates**. So that templates may keep subtly invading the language, one syntactic construct at a time.

So now calling our *is_same* metafunction has become a breeze:

```cpp
std::is_same_v<int, int>; // returns true
```

And of course, as you might have noticed, the standard library provides a variable template alias (that is, a *_v* equivalent) for each and every of its value-returning metafunctions.

## Conclusion

Like this post, metafunctions were really not meant to exist.

The template system was designed to bring generic programming to C++, so that things such as vectors could be easily used for integers (*vector<int>*) as well as for strings (*vector<string>*) without having to change the internal implementation. It was only later that some C++ developers found out that templates were actually a turing-complete DSL inside of C++... that also happened to be able to work with types.

From that point on, a very frequent C++ phenomena took place: the language was awkardly expanded with retro-compatibility in mind, and metafunctions evolved to have a simpler, yet still kind of foreign, syntax.

Still, metafunctions at their core are simple - or at least they're as simple as regular functions. All you need to understand to use them are a few levels of indirection to clean up their syntax a bit and keep them retro-compatible with the rest of C++. **Bjarne Stroustrup**, creator of the C++ language, once said this at a C++ conference:

> Within C++, there is a much smaller and clearer language struggling to get out.

If you had to only bring one thing away with you from this post, remember this phrase; and apply it to the context of metafunctions.
