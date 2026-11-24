# Dokumentation - Dokumenten Datenbank

## Anleitung für Prüfer
1. Daten bereitstellen
    1. Auf selber Ebene von Ordner **Abgabe 1** Ordner **src** erstellen
    2. In **src** Ordner **articles** erstellen und Spiegel Artikel hinein kopieren
    3. In **src** Ordner **articles_eng** erstellen und Englische Artikel mit den folgenden Schritten importieren
        1. https://github.com/Webhose/fake-news-dataset auschecken
        2. Alle Dateien entzippen
        3. Da die Dateien innerhalb der verschiedenen Ordner gleich benannt sind ("article_1" etc.), müssen sie umbenannt werden, um später im selben Kontext verwendet werden zu können. Hier bietet sich die Konkatination mit dem Namen des darüberliegenden Ordners an, in dem eine Datei liegt, da dieser eindeutig ist.
        4. Alle Dateien in einen Ordner verschieben
        5. Da der Datensatz eine Vielzahl von Dateien in anderen Sprachen als Englisch enthält, müssen die englischsprachigen Artikel herausgefiltert werden. Das wurde mit einem Filter über das JSON-tag "language": "english" erreicht.
        6. Datensatz in **articles_eng** kopieren
2. Falls der Docker Container mit der Datenbank nicht "docker-db-1" heißt muss die Variable **DOCKER_CONTAINER_NAME** in **main.py** entsprechend umbenannt werden
3. **python main.py** ausführen
4. Mittels Dialogfenster:
    1. Tabellen erstellen
    2. Daten importieren
    
## Arbeitsaufteilung
+ Leonard und Yannick: Schreiben Skript für das Erstellen der Datenbank und das Parsen der Deutschen Artikel
+ Ruben: Sucht nach passenden Englischen Artikeln -> https://github.com/Webhose/fake-news-dataset/tree/master sämmtliche Artikel importiert. Nur Artikel mit dem tag `"language": "english"` wurden in das Set für diese Aufgabe übernommen. 
+ Queries wurden gemeinsam in der Gruppe erarbeitet, zum Teil aufgeteilt und dann zusammen besprochen

## Auffälligkeiten
+ Datei mit dem Namen "6814f4f4-117a-4ca1-98ec-53ee598f283f.json" beinhaltet den gleichen JSON Inhalt hintereinander. Zweiter Inhalt wurde gelöscht damit import fehlerfrei läuft.