# Use Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy files
COPY app/ ./app/
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port Flask will run on
EXPOSE 8080

# Run the Flask app
CMD ["python", "app/main.py"]
