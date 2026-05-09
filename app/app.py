from flask import Flask, jsonify
import socket, datetime, os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'app' : 'AWS DR System',
        'status' : 'healthy',
        'region' : os.environ.get('AWS_REGION', 'local'),
        'hostname' : socket.gethostname(),
        'timestamp' : str(datetime.datetime.utcnow())
    })

@app.route('/health')
def health():
    return jsonify({'status': 'ok'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
