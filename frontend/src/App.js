import React from "react";
import { Routes, Route } from "react-router-dom";
import DoctorRegistrationForm from "./Pages/DoctorRegistrationForm";
import DoctorSignIn from "./Pages/Singin";

const App = () => {
  return (
      <div className="flex-grow">
        <Routes>
          <Route path="/" element={< DoctorSignIn/>} />
          <Route path="/registration" element={<DoctorRegistrationForm />} />
        </Routes>
      </div>
  )
};

export default App;

