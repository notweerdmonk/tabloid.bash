# tabloid.bash

A bash implementation[^1] of [Tabloid](https://github.com/thesephist/tabloid), the clickbait programming language.

---

```console
$ ./runtabloid prog
Program
EXPERTS CLAIM a TO BE 10
EXPERTS CLAIM b TO BE 100
YOU WON'T WANT TO MISS a PLUS b

PLEASE LIKE AND SUBSCRIBE

Output
110

$ time ./runtabloid fibo
Program
DISCOVER HOW TO fibonacci WITH n
RUMOR HAS IT
    WHAT IF n SMALLER THAN 2
        SHOCKING DEVELOPMENT n
    LIES! RUMOR HAS IT
        SHOCKING DEVELOPMENT
            fibonacci OF n MINUS 2 PLUS fibonacci OF n MINUS 1
    END OF STORY
END OF STORY

YOU WON'T WANT TO MISS 'Fibonacci number'
YOU WON'T WANT TO MISS fibonacci OF 4

PLEASE LIKE AND SUBSCRIBE

Output
Fibonacci number
3


real    0m27.589s
user    0m22.252s
sys     0m6.022s
$
$ time ./runtabloid fibo2
Program
DISCOVER HOW TO fibonacci WITH n
RUMOR HAS IT
    WHAT IF n IS ACTUALLY 0
        SHOCKING DEVELOPMENT 0
    LIES! RUMOR HAS IT
        WHAT IF n IS ACTUALLY 1
            SHOCKING DEVELOPMENT 1
        LIES!
            SHOCKING DEVELOPMENT
                fibonacci OF n MINUS 2 PLUS fibonacci OF n MINUS 1
    END OF STORY
END OF STORY

YOU WON'T WANT TO MISS 'Fibonacci number'
YOU WON'T WANT TO MISS fibonacci OF 4

PLEASE LIKE AND SUBSCRIBE

Output
Fibonacci number
3


real    0m56.749s
user    0m46.434s
sys     0m11.570s
```

[^1]: b3VyIHNvdXJjZXMgYXJlIGRpc2NyZXRl
