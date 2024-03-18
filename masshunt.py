from urllib.request import urlopen
from sys import argv, exit

def check(url):
    ''' check given URL is vulnerable or not '''

    try:
        if "http" not in url: url = "http://" + url

        data = urlopen(url)
        headers = data.info()

        if not "X-Frame-Options" in headers: return True

    except: return False


def create_poc(url):
    ''' create HTML page of given URL '''

    code = """
<html>
   <head><title>Clickjack test page</title></head>
   <body>
     <p>Website is vulnerable to clickjacking!</p>
     <iframe src="{}" width="500" height="500"></iframe>
   </body>
</html>
    """.format(url)

    with open(url + ".html", "w") as f:
        f.write(code)
        f.close()


def main():

    try: sites = open(argv[1], 'r').readlines()
    except: print("[*] Usage: python(3) masshunt.py <file_name>"); exit(0)

    for site in sites[0:]:
        print("\n[*] Checking " + site)
        status = check(site)

        if status:
            print("\033[91m [+] Website is vulnerable!\033[0m")
            create_poc(site.split('\n')[0])
            print(" [*] Created a poc and saved to <URL>.html")

        elif not status: print(" [-] Website is not vulnerable!")
        else: print('Every single thing is crashed, Python got mad, dude wtf you just did?')

if __name__ == '__main__': main()
