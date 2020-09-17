#!/usr/bin/env python
import pika

credentials = pika.PlainCredentials('test', 'test')
connection = pika.BlockingConnection(pika.ConnectionParameters(host='184.73.149.108', port=5672, virtual_host='/', credentials=credentials, ssl_options=None))

channel = connection.channel()

channel.queue_declare(queue='test', durable=True)

channel.basic_publish(exchange='', routing_key='test', body='Hello World!22')
print(" [x] Sent 'Hello World!'")
connection.close()