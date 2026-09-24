---// Source - https://stackoverflow.com/q/79874608
// Posted by Vincent Nivoliers, modified by community. See post 'Timeline' for change history
// Retrieved 2026-01-30, License - CC BY-SA 4.0

int main()
{
  using nil = decltype(nullptr) ;
  constexpr nil zero = nullptr ;
  constexpr nil other_zero = zero ;
}

title: Languages
layout: en

---

Here's a list of tutorials for using Travis CI with different programming
languages:

{% include languages.html %}

> You can also have a look at the [Language](https://config.travis-ci.com/ref/language) section in our [Travis CI Build Config Reference](https://config.travis-ci.com/).
