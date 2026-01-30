#!/usr/bin/env python3
import boto3
import os
from pathlib import Path

def main():
    session = boto3.session.Session()
    s3 = session.client(
        service_name='s3',
        endpoint_url=os.environ.get('S3_ENDPOINT'),
        aws_access_key_id=os.environ.get('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.environ.get('AWS_SECRET_ACCESS_KEY')
    )
    
    bucket_name = os.environ.get('BUCKET_NAME')
    
    exclude_files = {
        'index.html', 
        'README.md', 
        'readme.md', 
        'last_synced_commit.txt', 
        '.gitignore', 
        'encrypt_files.sh'
    }
    
    uploaded_count = 0
    
    for item in Path('.').rglob('*'):
        if item.is_file():
            filename = item.name
            
            if filename in exclude_files:
                continue
                
            if '.git' in str(item):
                continue
                
            try:
                s3.upload_file(
                    str(item),
                    bucket_name,
                    filename
                )
                uploaded_count += 1
                print(f'Uploaded: {filename}')
            except Exception as e:
                print(f'Error uploading {filename}: {e}')
    
    print(f'Total files uploaded: {uploaded_count}')

if __name__ == '__main__':
    main()
