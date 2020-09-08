### In this directory

file | description
--- | ---
[lib/](../../../tree/master/lexeme-translator/lib)  | Libraries
[resolver.api.L1.fth](resolver.api.L1.fth)          | Minimal supporting API level: `PERCEPTOR` and `SET-PERCEPTOR` words.
[resolver.api.L2.fth](resolver.api.L2.fth)          | Methods to manage the resolvers.
[ttoken.stdlib.fth](ttoken.stdlib.fth)              | Token translators for the standard tokens (`xt`, numbers, strings).
[resolver.stdlib.fth](resolver.stdlib.fth)          | Resolvers for the standard lexeme types (words, literals).
[core.example.fth](core.example.fth)                | Example definitons of some standard words
[common.example.fth](common.example.fth)            | Support for some well known lexeme types and markup example.
[advanced.example.fth](advanced.example.fth)        | More elaborate technique examples.
[index.fth](index.fth)                              | Index file to load all at once.
[variation/](../../../tree/master/lexeme-translator/variation)      | Other implementation variants that conform to the proposed specification.


### In [../docs](../../../tree/master/docs) directory

 - [ttoken.fth](../docs/ttoken.fth) — an explanation regarding the token translators (definition variants).
 - [resolver-api.md](../docs/resolver-api.md) — a formal specification.


### See also

 - [resolver-vs-recognizer](https://ruv.github.io/forth-design-exp/resolver-vs-recognizer.xml) — a comparison with Recognizer RFD v4.
