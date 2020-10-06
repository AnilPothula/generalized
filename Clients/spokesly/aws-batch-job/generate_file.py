#!/usr/bin/env python

import os
import logging
import random 
import string

'''
HTML file will be created and content will be taken fom
pre-defined object
'''
def create_file(htmlData, BUCKET_NAME):
    # Create Random File
    randomFileName = 'file' + ''.join(random.sample(string.ascii_uppercase + string.digits, k=4))
    f = open(randomFileName + '.html', 'w')

    message = """<html>
                <head></head>
                <body><p>"""+htmlData+"""</p></body>
                </html>"""
    f.write(message)
    f.close()
    d = dict()
    d['file'] = randomFileName +'.html'
    d['link'] = 'https://'+BUCKET_NAME+'.s3.amazonaws.com/'+randomFileName+'.html'
    return d