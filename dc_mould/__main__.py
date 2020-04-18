import subprocess
from prompt_toolkit import PromptSession

from prompt_toolkit.output import create_output

from jinja2 import Environment, FileSystemLoader

import os
import sys

import re


if getattr(sys, 'frozen', False):
    scriptPath = sys._MEIPASS
else:
    scriptPath = os.path.dirname(os.path.realpath(__file__))


def newLaravel():
    sess = PromptSession()

    basePath = sess.prompt('Enter project name (use leading slash to input name with absolute path): ')

    if not basePath.startswith(os.sep):
        basePath = os.path.join(os.getcwd(), basePath)

    print("Creating docker environment folder (if it does not already exist).")
    os.makedirs(basePath, exist_ok=True)

    try:
        os.chdir(basePath)
    except OSError:
        print("Can't change to given directory.") 

    projectName = os.path.basename(basePath)

    userInput = {
        'app': {
            'name': projectName,
            'network_prefix': '',
            'url': '',
            'laravel_version': ''
        },
        'ide': {
            'key': 'phpstorm' # needed for xdebug.
        },
        'host': {
            'ip': '127.0.0.1' # needed for xdebug.
        }
    }

    userInput['app']['network_prefix'] = sess.prompt('Enter class C network ID prefix (eg. 192.168.42): ')
    userInput['app']['url'] = sess.prompt('Enter URL to access your app (eg. myawesomeapp.local): ')
    userInput['app']['laravel_version'] = sess.prompt('Enter Laravel version to use (v6.x.x is recommended): ', default='v6.18.8')

    stubLaravel(userInput)

    print("\r\nBe sure to point '%s.17' to IP '%s' in your 'hosts' file.\r\n" % (userInput['app']['network_prefix'], userInput['app']['url']))

    stubDockerEnvironment(userInput)


def stubLaravel(userInput):
    name = userInput['app']['name']
    laravelVersion = userInput['app']['laravel_version']

    out = create_output()
    myCwd = os.getcwd()

    if not os.path.exists(os.path.join(myCwd, name)):
        subprocess.call("docker run -it --rm --user $(id -u):$(id -g) -v $(pwd):/app -v ${COMPOSER_HOME:-$HOME/.composer}:/tmp composer create-project --prefer-dist laravel/laravel %s %s" % (name, laravelVersion), shell=True, stdout=out, stderr=out, cwd=myCwd)
    else:
        print("File or directory with given project name already exists. Stub creation skipped.")

    lines = []

    with open(os.path.join(myCwd, name, '.env'), 'r') as fh:
        text = fh.read()

        if not re.search(r"APP_URL=http://%s" % (userInput['app']['url']), text):
            lines.append("sed -i 's/APP_URL=http:\/\/localhost/APP_URL=http:\/\/%s/g' .env" % (userInput['app']['url']))

        if not re.search(r"DB_HOST=%s-database" % (name), text):
            lines.append("sed -i 's/DB_HOST=127.0.0.1/DB_HOST=%s-database/g' .env" % (name))

        if not re.search(r'DB_DATABASE=main', text):
            lines.append("sed -i 's/DB_DATABASE=laravel/DB_DATABASE=main/g' .env")

        if not re.search(r'DB_PASSWORD=password', text):
            lines.append("sed -i 's/DB_PASSWORD=/DB_PASSWORD=password/g' .env")

    for cmdLine in lines:
        subprocess.call(cmdLine, shell=True, stdout=out, stderr=out, cwd=os.path.join(myCwd, name))


def stubDockerEnvironment(userInput):
    file_loader = FileSystemLoader(os.path.join(scriptPath, 'templates'))

    env = Environment(loader=file_loader)

    targetRootName = userInput['app']['name'] + "-dc"
    
    myCwd = os.getcwd()

    for tplFile in env.list_templates():
        tplFileParts = tplFile.split(os.path.sep)
        targetFile = os.path.join(myCwd, *tplFileParts).replace('app-dc', targetRootName)

        onlyPath = os.path.dirname(targetFile)

        if not os.path.exists(onlyPath):
            os.makedirs(onlyPath, exist_ok=True)

        with open(targetFile, "w+") as targetFile: 
            tpl = env.get_template(tplFile)
            targetFile.write(tpl.render(data=userInput)) 

    os.chmod(os.path.join(myCwd, targetRootName, 'prepare.sh'), 0o755)

def main():    
    session = PromptSession()

    while True:
        try:
            print("1. Make Laravel 6 project.\r\n")
            text = session.prompt('> ')
        except KeyboardInterrupt:
            continue
        except EOFError:
            break
        else:
            if text == '1':
                newLaravel()

                print('You may now exit and start building your kickass application.')
                
    print('GoodBye!')


if __name__ == '__main__':
    main()