FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Train the model if it doesn't exist
RUN python train_model.py

EXPOSE 5000
CMD ["python", "app.py"]