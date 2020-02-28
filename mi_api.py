import pgdb
import json
import requests
from flask import abort
from datetime import datetime
from flask import make_response
from flask import Flask, request, jsonify

app = Flask(__name__)

def get_datetime():
	now = datetime.now()
	return(now.strftime("%Y-%m-%d %H:%M:%S"))

def insert_to_db(*args):
	mydb = pgdb.connect(
		host="localhost",
		user="postgres",
		password="superuser",
		database="postgres"
	)
	mycursor = mydb.cursor()
	sql = """
			INSERT INTO opensips_acc (method, from_tag, callid, sip_code, sip_reason, time, src_ip, caller,callee)
			VALUES ('INVITE', %s, %s, %s, %s, %s, %s, %s, %s);
		"""
	mycursor.execute(sql,args)
	mydb.commit()
	mydb.close()

def scraping_data():
	datas = {}
	resource_list = []
	url = 'http://localhost:8080/json/lb_list'
	req = requests.get(url)
	content = json.loads(req.content)
	indexes = content['Destination']
	for n in range(len(indexes)):
		gateway = indexes[n]['value'].split(":")[1]
		resources = indexes[n]['children']['Resources']['children']['Resource']
		if len(resources) > 1:
			for n in range(len(resources)):
				prefix = resources[n]['value']
				total = resources[n]['attributes']['max']
				load = resources[n]['attributes']['load']
				resource = {"prefix" : prefix,"max" : total,"load" : load}
				resource_list.append(resource)
			datas.update({gateway : resource_list})
			resource_list = []
		else:
			prefix = resources[0]['value']
			total = resources[0]['attributes']['max']
			load = resources[0]['attributes']['load']
			resource = {"prefix" : prefix,"max" : total,"load" : load}
			datas.update({gateway : resource})
	return datas

@app.errorhandler(404)
def not_found(error):
	return make_response(jsonify({'error': 'Not found'}), 404)

@app.route('/lb/data/gateways', methods=['GET'])
def get_data():
	data = scraping_data()
	gateway = request.args.get("gw")
	prefix = request.args.get("prefix")
	if (gateway != None and prefix == None) or (gateway != None and prefix != None):
		gw = [data[gw] for gw in data if gw == gateway]
		if gateway != None and prefix != None:
			if isinstance(gw[0],list) == True: gw = gw[0]
			else: gw = gw
			pfx = [data for data in gw if data['prefix'] == prefix]
			if len(pfx) == 0: abort(404)
			else: return jsonify(pfx)
		else:
			if len(gw) == 0: abort(404)
			else: return jsonify(gw)
	elif gateway == None and prefix != None: return '''<h2>Require gateway parameter</h2>'''
	else: return jsonify(data)

@app.route('/insert_db',methods=['POST'])
def update_db():
	db_data = request.get_json()
	from_tag = db_data['from_tag']
	callid = db_data['callid']
	sip_code = db_data['sip_code']
	sip_reason = db_data['sip_reason']
	src_ip = db_data['src_ip']
	caller = db_data['caller']
	callee = db_data['callee']
	dt = get_datetime()

	insert_to_db(from_tag,callid,sip_code,sip_reason,dt,src_ip,caller,callee)

	return '''<h2>Inserted into database</h2>''',201

if __name__ == '__main__':
	app.run(host="localhost",debug=True)
