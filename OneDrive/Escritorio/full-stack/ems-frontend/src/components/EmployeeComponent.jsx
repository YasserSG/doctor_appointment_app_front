import React, {useEffect, useState } from 'react'
import { createEmployee, getEmployeeById, updateEmployee } from '../services/EmployeeService';
import {useNavigate, useParams } from 'react-router-dom';

const EmployeeComponent = () => {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [email, setEmail] = useState('');

    const {id} = useParams();
    const [error, setError] = useState({
        firstName:"",
        lastName:"",
        email:"",
    })

    const navigator = useNavigate();

    useEffect(() => {
        if(id) {
            getEmployeeById(id).then((response) => {
                setFirstName(employee.firstName);
                setLastName(employee.lastName);
                setEmail(employee.email);
            }).catch(error => {
                console.error(error);
            })
        }    
    }, [id]);

    function saveOrUpdateEmployee(e) {
        e.preventDefault();
        if(validateForm()){

        
            const employee = { firstName, lastName, email }
            console.log(employee)

            if(id) {
                updateEmployee(id, employee).then((response) => {
                    console.log(response.data);
                    navigator('/employees');
                }).catch(error => {
                    console.error(error);
                })
            } else {
                createEmployee(employee).then((response) => {
                console.log(response.data);
                navigator('/employees');
            }).catch(error => {
                console.error(error);
            })}

        }

    }

  function validateForm() {
        let Valid = true;
        
        const errorsCopy = { ...error }

        if(firstName.trim()) {
            errorsCopy.firstName = "";
        } else {
            errorsCopy.firstName = "First Name is required";
            Valid = false;
        }

        if(lastName.trim()) {
            errorsCopy.lastName = "";
        } else {
            errorsCopy.lastName = "Last Name is required";
            Valid = false;
        }

        if(email.trim()) {
            errorsCopy.email = "";
        } else {
            errorsCopy.email = "Email is required";
            Valid = false;
        }

        setError(errorsCopy);
        return Valid;

    }    

    function pageTitle() {
        if(id) {
            return <h2 className="text-center">Update Employee</h2>
        } else {
            return <h2 className="text-center">Add Employee</h2>
        }
    }

  return (
    <div className="container">
        <br /> <br /> 
        <div className="row">
            <div className="card col-md-6 offset-md-3 offset-md-3">
                {  
                pageTitle()
                }
                <h2 className="text-center">Add Employee</h2>
                <div className="card-body">
                    <form>
                        <div className="form-group mb-2">
                            <label className="form-label">First Name</label>
                            <input
                                type="text" 
                                placeholder="Enter First Name" 
                                name="firstName" 
                                value={firstName}
                                className={`form-control  ${ error.firstName ? "is-invalid" : ""}`}
                                onChange ={(e) => setFirstName(e.target.value)}
                             />    
                            {error.firstName && <div className="invalid-feedback">{error.firstName}</div> }
                        </div>

                        <div className="form-group mb-2">
                            <label className="form-label">Last Name</label>
                            <input
                                type="text" 
                                placeholder="Enter Last Name" 
                                name="lastName" 
                                value={lastName}
                                className={`form-control  ${ error.lastName ? "is-invalid" : ""}`}
                                onChange={(e) => setLastName(e.target.value)} 
                             />
                            {error.lastName && <div className="invalid-feedback">{error.lastName}</div> }   
                        </div>

                        <div className="form-group mb-2">
                            <label className="form-label">Email</label>
                            <input
                                type="email" 
                                placeholder="Enter Employee Email" 
                                name="email" 
                                value={email}
                                className={`form-control  ${ error.email ? "is-invalid" : ""}`}
                                onChange={(e) => setEmail(e.target.value)} 
                             />
                            {error.email && <div className="invalid-feedback">{error.email}</div> }    
                        </div>

                        <button className="btn btn-success" onClick={saveOrUpdateEmployee} >Submit</button>
                    </form>

                </div>
            </div>

        </div>

     </div>   
  )
}

export default EmployeeComponent