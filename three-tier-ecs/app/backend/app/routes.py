from flask import Blueprint, jsonify, request
from .models import db, Student, Attendance

bp = Blueprint('main', __name__)

@bp.route('/api/students')
def index():
    students = Student.query.all()
    return jsonify({"students": [{"id": s.id, "name":s.name} for s in students]})

@bp.route('/api/students', methods=['POST'])
def add_student():
    data = request.get_json()   
    name = data['name']
    new_student = Student(name=name)
    db.session.add(new_student)
    db.session.commit()
    return jsonify({"message": "Student added succesfully"})

@bp.route('/api/attendance', methods=['POST'])
def mark_attendance():
    data = request.get_json() 
    student_id = data['student_id']
    status = data['status']
    new_attendance = Attendance(student_id=student_id, status=status)
    db.session.add(new_attendance)
    db.session.commit()
    return jsonify({"message": "Attendance marked successfully"})