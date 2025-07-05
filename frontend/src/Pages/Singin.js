import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { toast, ToastContainer } from "react-toastify";
import ClipLoader from "react-spinners/ClipLoader";
import "react-toastify/dist/ReactToastify.css";
import BGImage from "../assets/BGImage.jpg"
import GreenTexture from "../assets/GreenTexture.jpg";
// import OneAppLogo from "../../images/oneapp_logo.png"; // Use your actual logo path
import SignInBG from "../assets/green_bg.png"; // Or use an online green image

const DoctorSignIn = () => {
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);

    const [formData, setFormData] = useState({
        email: "",
        password: "",
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({
            ...prev,
            [name]: value,
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!formData.email || !formData.password) {
            toast.error("Please enter email and password");
            return;
        }

        setLoading(true);

        try {
            // ✅ Replace with your real sign-in API
            console.log("Signing in with:", formData);

            // Fake success:
            toast.success("Sign in successful!");
            setTimeout(() => navigate("/dashboard"), 1500);
        } catch (err) {
            toast.error("Invalid credentials");
        } finally {
            setLoading(false);
        }
    };

    return (
        <section
            className="min-h-screen flex items-center justify-center px-4 py-4 bg-cover bg-center"
            style={{ backgroundImage: `url(${BGImage})` }}
        >
            <ToastContainer />
            <div
                className="w-full max-w-xl p-4 rounded-lg"
                style={{
                    backgroundImage: `url(${GreenTexture})`,
                    backgroundSize: 'cover',
                    backgroundPosition: 'center',
                }}
            >
                <div className="  p-4 md:p-4 rounded-lg">
                    {/* Left Side */}
                    {/* <div className="hidden md:block w-1/2 relative">
                    <img
                        src={SignInBG}
                        alt="Sign In BG"
                        className="absolute inset-0 w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-green-900 bg-opacity-50 flex flex-col items-center justify-center text-white p-8">
                        <h2 className="text-3xl font-bold mb-4">New to OneApp?</h2>
                        <p className="mb-6">Create your doctor account today!</p>
                        <Link
                            to="/registration"
                            className="text-green-300 font-semibold underline"
                        >
                            Sign up
                        </Link>
                    </div>
                </div> */}

                    {/* Right Side */}
                    <div className="w-full ">
                        <div className="flex justify-center items-center mb-6">
                            {/* <img src={OneAppLogo} alt="OneApp Logo" className="w-12 h-12 mr-2" /> */}
                            <h1 className="text-2xl font-bold text-green-800">OneApp</h1>
                        </div>

                        <h2 className="text-xl font-bold text-green-800 mb-6">Sign in</h2>

                        <form onSubmit={handleSubmit} className="space-y-4">
                            <div>
                                <label
                                    htmlFor="email"
                                    className="block mb-2 text-md font-medium text-gray-700"
                                >
                                    Email
                                </label>
                                <input
                                    type="email"
                                    name="email"
                                    id="email"
                                    value={formData.email}
                                    onChange={handleChange}
                                    placeholder="doctor@example.com"
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"
                                    required
                                />
                            </div>

                            <div>
                                <label
                                    htmlFor="password"
                                    className="block mb-2 text-md font-medium text-gray-700"
                                >
                                    Password
                                </label>
                                <input
                                    type="password"
                                    name="password"
                                    id="password"
                                    value={formData.password}
                                    onChange={handleChange}
                                    placeholder="••••••••"
                                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg block w-full p-2.5"
                                    required
                                />
                            </div>

                            <button
                                type="submit"
                                disabled={loading}
                                className="w-full bg-green-700 hover:bg-green-800 text-white font-medium rounded-lg text-md py-2.5"
                            >
                                {loading ? (
                                    <>
                                        <ClipLoader size={20} color="#ffffff" /> Signing in...
                                    </>
                                ) : (
                                    "Sign in"
                                )}
                            </button>

                            <p className="text-sm text-gray-500 text-center mt-2">
                                By signing in, you agree to our{" "}
                                <a href="#" className="text-green-700 font-medium underline">
                                    Terms
                                </a>{" "}
                                and{" "}
                                <a href="#" className="text-green-700 font-medium underline">
                                    Conditions
                                </a>.
                            </p>
                            <div className="flex justify-center ">
                            <p className="mb-6 ">Create your doctor account today!</p>
                            <Link
                                to="/registration"
                                className="text-green-700 font-semibold underline"
                            >
                                Sign up
                            </Link>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    );
};

export default DoctorSignIn;
