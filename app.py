import sqlite3
from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# Database connection function
def get_db_connection():
    conn = sqlite3.connect('database/quran_tafsir.db')
    conn.row_factory = sqlite3.Row  # Access columns by name
    return conn

# Home route - Display the Juz list and Surah selection
@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch all Juz data for the dropdown
    cursor.execute('SELECT * FROM Juz')
    juz_data = cursor.fetchall()

    # Fetch all Surahs for Surah selection
    cursor.execute('SELECT * FROM Surah')
    surahs = cursor.fetchall()

    conn.close()

    return render_template('index.html', juz_data=juz_data, surahs=surahs)

# Route to fetch Tafsir based on Surah ID
@app.route('/tafsir/<surah_id>', methods=['GET'])
def get_tafsir(surah_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch all Ayahs for the given Surah ID
    cursor.execute('''
        SELECT Ayah.id AS ayah_id, Surah.name AS surah_name, Ayah.number_in_surah, Ayah.text AS arabic_text, 
               Tafsir.tafsir_text AS amharic_translation
        FROM Ayah
        JOIN Surah ON Ayah.surah_id = Surah.id
        LEFT JOIN Tafsir ON Ayah.id = Tafsir.ayah_id
        WHERE Surah.id = ?
        ORDER BY Ayah.number_in_surah
    ''', (surah_id,))
    tafsir_data = cursor.fetchall()

    conn.close()

    # Prepare the data to send as JSON
    tafsir_list = []
    for row in tafsir_data:
        tafsir_list.append({
            'surah_name': row['surah_name'],
            'ayah_number': row['number_in_surah'],
            'arabic_text': row['arabic_text'],
            'amharic_translation': row['amharic_translation'] if row['amharic_translation'] else "No translation available"
        })

    return jsonify(tafsir_list)

# Route to fetch Surah details based on Juz ID
@app.route('/juz/<juz_id>', methods=['GET'])
def get_surahs_by_juz(juz_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch Surahs associated with a specific Juz ID
    cursor.execute('SELECT * FROM Surah WHERE juz_id = ?', (juz_id,))
    surahs = cursor.fetchall()

    conn.close()

    # Prepare the data to send as JSON
    surah_list = []
    for row in surahs:
        surah_list.append({
            'id': row['id'],
            'name': row['name'],
            'arabic_name': row['arabic_name'],
            'verse_count': row['verse_count']
        })

    return jsonify(surah_list)

# Route to display a specific Surah's Tafsir in the HTML page
@app.route('/surah/<surah_id>', methods=['GET'])
def surah_page(surah_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    # Fetch Surah details
    cursor.execute('SELECT * FROM Surah WHERE id = ?', (surah_id,))
    surah = cursor.fetchone()

    # Fetch the Tafsir for the Surah
    cursor.execute('''
        SELECT Ayah.number_in_surah, Ayah.text AS arabic_text, Tafsir.tafsir_text AS amharic_translation, Tafsir.author 
        FROM Ayah
        JOIN Surah ON Ayah.surah_id = Surah.id
        LEFT JOIN Tafsir ON Ayah.id = Tafsir.ayah_id
        WHERE Surah.id = ?
        ORDER BY Ayah.number_in_surah
    ''', (surah_id,))
    tafsir_data = cursor.fetchall()

    conn.close()

    return render_template('surah.html', surah=surah, tafsir_data=tafsir_data)

# Main entry point
if __name__ == '__main__':
    app.run(debug=True)