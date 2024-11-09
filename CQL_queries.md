# Searching the WIBARAB Corpus

## Sample Queries
**NOTE**: For these queries to work, you need to have "CQL" selected as the query type in the Advanced tab of the Concordance tool
### How do I search for stress?

`[word=".*´.*"]`

### How to search for words ending either with “um” or “am”? 

`[word=".*(um|am)"]`

### How to search for words ending either with “um” or “am” with a dash in the beginning? 

`<connecteds/> containing [word=".*(um|am)"]` 

### How to search for words containing a special character, e.g. č? 

If `[word=".*č.*"]` (or whatever else you're looking for instead of č) doesn't work, try `[decomp=".*č.*"]` instead