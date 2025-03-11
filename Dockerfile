# Use lightweight Python image
FROM python:3.11-slim

# Set environment variables to reduce buffer and maximize memory
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create a directory for the app
WORKDIR /app

# ✅ Copy all project files into the container
COPY . .


# Install system dependencies (only necessary ones)
RUN apt-get update && apt-get install -y \
    libgtk-3-dev \
    libopenblas-dev \
    liblapack-dev \
    python3-opencv \
    libx11-dev \
    && rm -rf /var/lib/apt/lists/*



# ✅ STEP 1: Install your pre-built dlib wheel (VERY IMPORTANT)
COPY ./wheels/dlib-19.24.6-cp311-cp311-linux_x86_64.whl /app/wheels/
RUN pip install /app/wheels/dlib-19.24.6-cp311-cp311-linux_x86_64.whl

# ✅ STEP 2: Now install remaining dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt




# Collect static files
RUN python manage.py collectstatic --noinput


# Expose the port Django runs on
EXPOSE 8000


# Run the application
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000"]
