import './App.css'
import HeaderComponent from './components/HeaderComponent'
import ListEmployeeComponent from './components/ListEmployeeComponent'
import {BrowserRouter, Routes, Route} from 'react-router-dom'
import FooterComponent from './components/FooterComponent'
import EmployeeComponent from './components/EmployeeComponent'


function App() {


  return (
    <>
      <BrowserRouter>
        <HeaderComponent />
          <Routes>
          {/* // http://localhost:3000*/}
            <Route path="/" element={<ListEmployeeComponent />}></Route>
            {/* // http://localhost:3000/employees */}
            <Route path="/employees" element={<ListEmployeeComponent />}></Route>
            {/* // http://localhost:3000/add-employees */}
            <Route path="/employees/add" element={<EmployeeComponent />}></Route>

             {/* // http://localhost:3000/edit-employees/1 */}
            <Route path="/edit-employees/:id" element= {<EmployeeComponent /> }></Route>
          </Routes>
        <FooterComponent />
      </BrowserRouter>
    </>
  )
}

export default App
