import json
import sys

for repo in json.load(sys.stdin):
    clone_uri = repo.get('clone_uri')
    if clone_uri is not None:
        print repo['repo_id']
