# Dokumentation - Dokumenten Datenbank

## Anleitung für Prüfer
1. Daten bereitstellen
    1. Auf selber Ebene von Ordner **Abgabe 1** Ordner **src** erstellen
    2. In **src** Ordner **articles** erstellen und Spiegel Artikel hinein kopieren
    3. In **src** Ordner **articles_eng** erstellen und Englische Artikel mit den folgenden Schritten importieren
        1. TODO: Ruben Datei Import
2. **python main.py** ausführen
3. Mittels Dialogfenster:
    1. Tabellen erstellen
    2. Daten importieren
    
## Arbeitsaufteilung
+ Leonard und Yannick: Schreiben Skript für das Erstellen der Datenbank und das Parsen der Deutschen Artikel
+ Ruben: Sucht nach passenden Englischen Artikeln -> https://github.com/Webhose/fake-news-dataset/tree/master sämmtliche Artikel importiert. Nur Artikel mit dem tag `"language": "english"` wurden in das Set für diese Aufgabe übernommen. 
+ Queries wurden gemeinsam in der Gruppe erarbeitet, zum Teil aufgeteilt und dann zusammen besprochen

## Auffälligkeiten
+ Datei mit dem Namen "6814f4f4-117a-4ca1-98ec-53ee598f283f.json" beinhaltet den gleichen JSON Inhalt hintereinander. Zweiter Inhalt wurde gelöscht damit import fehlerfrei läuft.