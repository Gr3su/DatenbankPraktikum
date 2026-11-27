from pathlib import Path
import psycopg
import spiegel_importer
import english_importer
import subprocess
import os

DOCKER_CONTAINER_NAME = "docker-db-1"

def create_table():
    with psycopg.connect("user=postgres password=postgres host=localhost") as conn:
        with conn.cursor() as cur:
            cur.execute("CREATE TABLE IF NOT EXISTS articles(" \
                        "article jsonb NOT NULL,"
                        "isEnglishArticle boolean)")
            conn.commit()

def import_spiegel_articles():
    spiegel_importer.import_articles()

def import_english_articles():
    english_importer.import_articles()

def read_benchmarks():
    BASE_DIR = Path(__file__).resolve().parent
    benchmarks = BASE_DIR / "benchmarks"
    
    benchmark_files = [file for file in benchmarks.iterdir() if file.is_file()]
    print("\nVerfügbare Benchmark-Dateien:")
    for i, f in enumerate(benchmark_files):
        print(f"[{i}] {f.name}")

    choice = int(input("Bitte wähle eine Benchmark-Datei aus : "))
    print(f"Ausgewählte Benchmark-Datei: {benchmark_files[choice]}")
    return benchmark_files[choice]

def execute_pgbench(benchmark_file, clients: int = 10, jobs: int = 4, duration: int = 30):
    sql_content = benchmark_file.read_text(encoding="utf-8")

    cmd = [
        "docker", "exec",
        "-i",
        "-e", "PGPASSWORD=postgres",  
        DOCKER_CONTAINER_NAME,
        "pgbench",
        "-h", "localhost",  
        "-p", "5432",
        "-U", "postgres",
        "-c", str(clients),
        "-j", str(jobs),
        "-T", str(duration),
        "-f", "-",         
        "postgres",
    ]

    try:
        result = subprocess.run(
            cmd,
            input=sql_content,  
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Fehler beim Ausführen von pgbench:")
        print(e.stderr)

def explain_benchmark(benchmark_file):
    sql_content = benchmark_file.read_text(encoding="utf-8").strip().rstrip(";")
    try:
        with psycopg.connect("user=postgres password=postgres host=localhost") as conn:
            with conn.cursor() as cur:
                cur.execute(f"EXPLAIN (ANALYZE, BUFFERS) {sql_content}")
                for row in cur.fetchall():
                    print(row[0])
            conn.rollback()
    except psycopg.Error as e:
        print("Fehler beim Ausführen von EXPLAIN:")
        print(e)

def apply_optimizations():
    BASE_DIR = Path(__file__).resolve().parent
    folder = BASE_DIR / "optimizations"

    scripts = sorted(f for f in folder.glob("*.sql") if f.is_file()) if folder.is_dir() else []
    if not scripts:
        print("\nKeine Optimierungsskripte im Ordner 'optimizations' gefunden.")
        return

    print("\nVerfügbare Optimierungsskripte:")
    for i, f in enumerate(scripts):
        print(f"[{i}] {f.name}")
    print("[a] Alle ausführen")

    choice = input("Bitte wähle ein Skript aus: ").strip().lower()
    if choice == "a":
        selected = scripts
    else:
        try:
            selected = [scripts[int(choice)]]
        except (ValueError, IndexError):
            print("Ungültige Auswahl.")
            return

    # autocommit, damit z.B. CREATE INDEX CONCURRENTLY funktioniert
    try:
        with psycopg.connect("user=postgres password=postgres host=localhost", autocommit=True) as conn:
            for script in selected:
                print(f"Führe {script.name} aus...")
                try:
                    conn.execute(script.read_text(encoding="utf-8"))
                    print(f"{script.name} erfolgreich ausgeführt.")
                except psycopg.Error as e:
                    print(f"Fehler in {script.name}:")
                    print(e)
                    break
    except psycopg.Error as e:
        print("Fehler bei der Datenbankverbindung:")
        print(e)

def read_pgbench_parameters():
    try:
        skip = input("Möchtest du die Standardwerte für Clients (10), Jobs (4) und Dauer (30) verwenden? (j/n): ").strip().lower()
        if skip == "j" or skip == "":
            clients, jobs, duration = 10, 4, 30
        else:
            clients = int(input("Anzahl der Clients (Standard: 10): "))
            jobs = int(input("Anzahl der Jobs (Standard: 4): "))
            duration = int(input("Dauer in Sekunden (Standard: 30): "))
    except ValueError:
        print("Ungültige Eingabe. Verwende Standardwerte.")
        clients, jobs, duration = 10, 4, 30

    return clients, jobs, duration

def start_pgbench_dialog():
    while True:
        print("\n#####\npgbench Dialog\n#####")
        print("[0] Beenden")
        print("[1] Benchmarks auflisten und ausführen")
        print("[2] Benchmark mit EXPLAIN ANALYZE analysieren")
        print("[3] Optimierungen ausführen")

        choice = input("Bitte wähle eine Option: ")

        if choice == "0":
            print("Beende den pgbench Dialog...")
            break
        elif choice == "1":
            benchmark = read_benchmarks()
            clients, jobs, duration = read_pgbench_parameters()
            print(f"Führe Benchmark {benchmark.name} aus...")
            execute_pgbench(benchmark, clients=clients, jobs=jobs, duration=duration)
        elif choice == "2":
            benchmark = read_benchmarks()
            print(f"Führe EXPLAIN ANALYZE für {benchmark.name} aus...")
            explain_benchmark(benchmark)
        elif choice == "3":
            apply_optimizations()
        else:
            print("Ungültige Option. Bitte wähle erneut.")

while True:
    print("\n#####\nHauptmenü\n#####")
    print("[0] Beenden")
    print("[1] Tabelle für Artikel erstellen")
    print("[2] Spiegel-Artikel importieren")
    print("[3] Englische-Artikel importieren")
    print("[4] Alle Artikel importieren")
    print("[5] pgbench Dialog starten")

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
    elif choice == "3":
        import_english_articles()
        print("Englische-Artikel wurden importiert.")
    elif choice == "4":
        import_spiegel_articles()
        import_english_articles()
        print("Alle Artikel wurden importiert.")
    elif choice == "5":
        start_pgbench_dialog()
    else:
        print("Ungültige Option. Bitte wähle erneut.")