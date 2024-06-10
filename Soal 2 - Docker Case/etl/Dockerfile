# Gunakan image Python 3.11.4 sebagai base
FROM python:3.11.4-slim

# Set direktori kerja di dalam container
WORKDIR /app

# Salin requirements.txt ke direktori kerja
COPY requirements.txt .

# Instal dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Salin seluruh isi folder etl ke direktori kerja
COPY . .

# Jalankan ETL script
CMD ["python", "etl.py"]
