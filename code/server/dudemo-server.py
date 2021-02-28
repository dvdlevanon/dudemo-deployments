from http.server import BaseHTTPRequestHandler, HTTPServer
import mysql.connector
import time
import os

def get_handler(cnx):
	class HttpHandler(BaseHTTPRequestHandler, object):
		def __init__(self, *args, **kwargs):
			super(HttpHandler, self).__init__(*args, **kwargs)
			self.cnx = cnx
		
		def do_GET(self):
			print("Getting get ", self.path)
			upsert = "INSERT INTO get_stat VALUES (\"" + self.path + "\", 1) ON DUPLICATE KEY UPDATE count=count+VALUES(count)"
			cnx.cursor().execute(upsert)
			cnx.commit()
			self.send_response(200)
			self.end_headers()
			curser = cnx.cursor()
			curser.execute("SELECT count FROM get_stat WHERE path = \"" + self.path + "\"")
			called_count = curser.fetchone()
			self.wfile.write("GET request for {} called {} times\n".format(self.path, called_count[0]).encode('utf-8'))
		
		def do_POST(self):
			content_length = int(self.headers['Content-Length'])
			post_data = self.rfile.read(content_length)
			print("Getting post ", self.path, " data: ", post_data)
			upsert = "INSERT INTO post_stat VALUES (\"" + self.path + "\", 1) ON DUPLICATE KEY UPDATE count=count+VALUES(count)"
			cnx.cursor().execute(upsert)
			cnx.commit()
			self.send_response(200)
			self.end_headers()
			curser = cnx.cursor()
			curser.execute("SELECT count FROM post_stat WHERE path = \"" + self.path + "\"")
			called_count = curser.fetchone()
			self.wfile.write("POST request for {} called {} times\n".format(self.path, called_count[0]).encode('utf-8'))
	
	return HttpHandler

def setup_mysql_connection(host, user, password, dbname):
	while (True):
		try:
			cnx = mysql.connector.connect(user=user, password=password, host=host, database=dbname)
			return cnx
		except Exception as e:
			print ("Mysql connection failed", e)
			time.sleep(1)
			
def prepare_schema(cnx):
	cnx.cursor().execute("CREATE TABLE IF NOT EXISTS get_stat (path varchar(512) PRIMARY KEY, count int);")
	cnx.cursor().execute("CREATE TABLE IF NOT EXISTS post_stat (path varchar(512) PRIMARY KEY, count int);")
	
def run_server(port, cnx):
	httpd = HTTPServer(('', int(port)), get_handler(cnx))
	try:
		print("Listning on port", port)
		httpd.serve_forever()
	except KeyboardInterrupt:
		pass
	httpd.server_close()

def main():
	host = os.environ.get('DUDEMO_SERVER_MYSQL_HOST')
	user = os.environ.get('DUDEMO_SERVER_MYSQL_USER')
	password = os.environ.get('DUDEMO_SERVER_MYSQL_PASS')
	dbname = os.environ.get('DUDEMO_SERVER_MYSQL_DB')
	port = os.environ.get('DUDEMO_SERVER_PORT')
	
	print ("db-host: ", host, 
		", db-user: ", user,
		", db-pass: ", password,
		", db-name: ", dbname,
		", port: ", port)
	
	cnx = setup_mysql_connection(host, user, password, dbname)
	prepare_schema(cnx)
	run_server(port, cnx)

main()
