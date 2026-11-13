import psycopg
import spiegel_importer

def create_table():
    with psycopg.connect("user=postgres password=postgres host=localhost") as conn:
        with conn.cursor() as cur:
            cur.execute("CREATE TABLE IF NOT EXISTS articles(" \
                        "article jsonb NOT NULL)")
            conn.commit()

def import_spiegel_articles():
    spiegel_importer.import_articles()

while True:
    print("Folgende Optionen stehen zur Verfügung:")
    print("[0] Beenden")
    print("[1] Tabelle für Artikel erstellen")
    print("[2] Spiegel-Artikel importieren")
    print("[4] Englische-Artikel importieren")

    choice = input("Bitte wähle eine Option: ")

    if choice == "0":
        print("Beende das Programm...")
        break
    elif choice == "1":
        create_table()
        print("Tabelle für Artikel wurde erstellt.")
    elif choice == "2":
        import_spiegel_articles()
        print("Spiegel-Artikel wurden importiert.")
    elif choice == "4":
        # TODO: Import von Englischen Artikeln
        print("Englische-Artikel wurden importiert.")