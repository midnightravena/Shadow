<div align="center">
  <br />
  <img src="https://github.com/midnightravena/Shadow/blob/main/assets/shadowdart.jpeg" alt="Project Banner">
  <br />
  <img src="https://img.shields.io/badge/-Dart-black?style=for-the-badge&logoColor=white&logo=dart&color=0c0c0c" alt="Made in dart" />
</div>

# Language Specification
- The language syntax is a mix of Go and JavaScript.
- It is also highly dynamic and enigmatic embeddable scripting language.
- Shadow script files have an `.shadow` extension.
- The [`compiler`](./packages/compiler) and [`vm`](./packages/vm) provides the compiler and the runtime for the language.
- The performance is reasonable for a mere scripting language.
- It can do `100000` iterations and function calls in around 225 milliseconds.

# Documentation

Visit [shadow docs](https://shadow.vercel.app).

# Example

```shadow
print := "Hello World!";
print(print);
```
