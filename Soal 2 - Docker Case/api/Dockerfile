# Gunakan image Python 3.11.4 sebagai base
FROM python:3.11.4-slim

# Set direktori kerja di dalam container
WORKDIR /app

# Salin requirements.txt ke direktori kerja
COPY requirements.txt .

# Instal dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Salin seluruh isi folder api ke direktori kerja
COPY . .

# Ekspose port yang digunakan oleh uvicorn
EXPOSE 6000

# Jalankan aplikasi dengan uvicorn
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "6000"]
