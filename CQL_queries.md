# Searching the WIBARAB Corpus

## Sample Queries

### How do I search for stress?

`[word=".*´.*"]`

### How to search for words ending either with “um” or “am”? 

`[word=".*(um|am)"]`

### How to search for words ending either with “um” or “am” with a dash in the beginning? 

`<connecteds/> containing [word=".*(um|am)"]` 

### How to search for words containing a special character, e.g. č? 

If `[word=".*č.*"]` (or whatever else you're looking for instead of č) doesn't work, try `[decomp=".*č.*"]` instead
