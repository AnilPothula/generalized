import numpy
import requests
import pandas


def get_landing_page_content(data_map):
    return '''<!DOCTYPE html>
                <html>
                    <head>
                        <title>Basic Web Page</title>
                    </head>
                    <body>
                Hello World!
                    </body>
                </html>'''


def get_landing_page_url(data_map):
    landing_page_id = data_map.get('id')
    if landing_page_id:
        return f'https://reachstream.spokesly.com/contact_data/{landing_page_id}'


def get_landing_page(data_map):
    return get_landing_page_url(data_map), get_landing_page_content(data_map)



def main():
    data_map = {
        "id": "12345",
        "first_name": "John",
        'last_name': 'Doe',
        'country': 'United States'
    }
    print(get_landing_page(data_map))