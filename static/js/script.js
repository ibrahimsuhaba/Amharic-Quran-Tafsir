document.getElementById('surahSelect').addEventListener('change', function() {
    var surahId = this.value;

    if (surahId) {
        fetch(`/tafsir/${surahId}`)
            .then(response => response.json())
            .then(data => {
                const tafsirContainer = document.getElementById('tafsirContainer');
                const tafsirTableBody = document.querySelector('#tafsirTable tbody');
                tafsirTableBody.innerHTML = '';

                // Loop through the data and populate the table
                data.forEach(ayah => {
                    const row = document.createElement('tr');

                    row.innerHTML = `
                        <td>${ayah.surah_name}</td>
                        <td>${ayah.ayah_number}</td>
                        <td>${ayah.arabic_text}</td>
                        <td>${ayah.amharic_translation}</td>
                    `;

                    tafsirTableBody.appendChild(row);
                });
            });
    }
});