# Source Code für die Lambda Funktion
Die Lambda Funktion wurde in Python geschrieben. 
Ursprünglich war die Idee eine ganzzahl Division durchzuführen.
Allerdings wurden die externen Requests (z.B. via curl oder via Formular auf der Webseite) nicht als Lambda Events geparsed und dadurch konnte nicht auf den Body zugegriffen werden.
Deshalb wird im Moment einfach ein String zurück gegeben.