import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { toast, ToastContainer } from "react-toastify";
import ClipLoader from "react-spinners/ClipLoader";
import MapPicker from "../Components/MapPicker";
import "react-toastify/dist/ReactToastify.css";
import BGImage from "../assets/BGImage.jpg";
import GreenTexture from "../assets/GreenTexture.jpg";
import SignInBG from "../assets/green_bg.png"; // ✅ Use any image for right side

const DoctorRegistration = () => {
  const [formData, setFormData] = useState({
    fullName: "",
    specialty: "",
    licenseNumber: "",
    email: "",
    country: "us",
    phoneNumber: "",
    password: "",
    confirmPassword: "",
    profilePicture: "",
    clinicName: "",
    clinicAddress: "",
    location: "",
  });

  const [showMap, setShowMap] = useState(false);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const [countryList] = useState([
    { code: "US", name: "United States", dialCode: "+1" },
    { code: "UK", name: "United Kingdom", dialCode: "+44" },
    { code: "CA", name: "Canada", dialCode: "+1" },
    { code: "AUS", name: "Australia", dialCode: "+61" },
    { code: "IND", name: "India", dialCode: "+91" },
    { code: "DE", name: "Germany", dialCode: "+49" },
    { code: "FRA", name: "France", dialCode: "+33" },
    { code: "JP", name: "Japan", dialCode: "+81" },
    { code: "CN", name: "China", dialCode: "+86" },
    { code: "BR", name: "Brazil", dialCode: "+55" },
  ]);

  const [selectedCountryCode, setSelectedCountryCode] = useState("+1");

  useEffect(() => {
    const selectedCountry = countryList.find(
      (country) => country.code === formData.country
    );
    if (selectedCountry) {
      setSelectedCountryCode(selectedCountry.dialCode);
    }
  }, [formData.country, countryList]);

  const handleChange = (e) => {
    const { name, value, files } = e.target;

    if (name === "country") {
      const selectedCountry = countryList.find(
        (country) => country.code === value
      );
      const newDialCode = selectedCountry ? selectedCountry.dialCode : "";

      // Remove existing dial code if present
      const currentNumber = formData.phoneNumber.replace(/^\+\d+\s*/, "");

      setFormData({
        ...formData,
        country: value,
        phoneNumber: `${newDialCode} ${currentNumber}`.trim(),
      });
      setSelectedCountryCode(newDialCode);

    } else if (name === "profilePicture" && files) {
      const file = files[0];
      if (file) {
        const reader = new FileReader();
        reader.onloadend = () => {
          setFormData({ ...formData, [name]: reader.result });
        };
        reader.readAsDataURL(file);
      } else {
        setFormData({ ...formData, [name]: "" });
      }
    } else {
      setFormData({ ...formData, [name]: value });
    }
  };


  const validateForm = () => {
    if (!formData.fullName.trim()) return toast.error("Full Name is required");
    if (!formData.specialty.trim()) return toast.error("Specialty is required");
    if (!formData.licenseNumber.trim())
      return toast.error("License Number is required");
    if (!formData.email.trim()) return toast.error("Email is required");
    if (!formData.phone.trim()) return toast.error("Phone Number is required");
    if (!formData.password.trim()) return toast.error("Password is required");
    if (formData.password !== formData.confirmPassword)
      return toast.error("Passwords do not match");
    if (!formData.clinicName.trim())
      return toast.error("Clinic Name is required");
    if (!formData.clinicAddress.trim())
      return toast.error("Clinic Address is required");
    if (!formData.location.trim()) return toast.error("Location is required");
    return true;
  };

  // ✅ Add this INSIDE handleSubmit, instead of just using formData.phoneNumber
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;

    setLoading(true);

    // ✅ Find dial code again (to be extra safe)
    const selectedCountry = countryList.find(
      (country) => country.code === formData.country
    );
    const dialCode = selectedCountry ? selectedCountry.dialCode : "";

    // ✅ Combine dial code + local number
    const fullPhoneNumber = `${dialCode}${formData.phoneNumber}`;

    // ✅ Now you can send this:
    const finalData = {
      ...formData,
      phoneNumber: fullPhoneNumber,
    };

    try {
      console.log("Submitting", finalData);
      toast.success("Doctor account created!");
      setTimeout(() => navigate("/"), 2000);
    } catch (err) {
      toast.error("Something went wrong");
    } finally {
      setLoading(false);
    }
  };
  const [gpsCoords, setGpsCoords] = useState(null);

  const handleUseGPS = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (pos) => {
          const { latitude, longitude } = pos.coords;
          setGpsCoords([latitude, longitude]);
          setShowMap(true);
        },
        (err) => {
          toast.error("Unable to get your location");
        }
      );
    } else {
      toast.error("Geolocation is not supported by your browser");
    }
  };

  return (
    <section
      className="min-h-screen flex items-center justify-center px-4 py-8 bg-cover bg-center"
      style={{ backgroundImage: `url(${BGImage})` }}
    >
      <ToastContainer />
      <div
        className="w-full max-w-5xl p-4 rounded-r-lg"
        style={{
          backgroundImage: `url(${GreenTexture})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
        }}
      >
        <div className=" backdrop-blur-sm p-4 md:p-4 rounded-lg">

          <div className="flex justify-center items-center mb-4">
            <h1 className="text-3xl font-bold text-green-800">OneApp</h1>
          </div>
          <h2 className="text-xl font-bold text-green-800 mb-4 text-center">
            Doctor Registration
          </h2>

          <form
            onSubmit={handleSubmit}
            className="grid grid-cols-1 md:grid-cols-2 gap-6"
          >
            <div className="space-y-4">
              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Full Name
                </label>
                <input
                  type="text"
                  name="fullName"
                  value={formData.fullName}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="Dr. John Doe"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Specialty
                </label>
                <input
                  type="text"
                  name="specialty"
                  value={formData.specialty}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="Cardiologist"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  License Number
                </label>
                <input
                  type="text"
                  name="licenseNumber"
                  value={formData.licenseNumber}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="LIC123456"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Email
                </label>
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="doctor@example.com"
                  required
                />
              </div>

              <div>
                <label className="block mb-2 text-sm font-medium text-gray-700">
                  Phone Number
                </label>
                <div className="flex">
                  <select
                    name="country"
                    value={formData.country}
                    onChange={handleChange}
                    className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-l-lg focus:ring-primary-600 focus:border-primary-600 block w-1/6 p-2.5"
                  >
                    {countryList.map((country) => (
                      <option key={country.name} value={country.code}>
                        {country.code}
                      </option>
                    ))}
                  </select>

                  <input
                    type="tel"
                    name="phoneNumber"
                    id="phoneNumber"
                    value={formData.phoneNumber}
                    onChange={handleChange}
                    className="bg-gray-50 border border-l-0 border-gray-300 text-gray-900 text-sm rounded-r-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5"
                    placeholder="+1 234 567 8900"
                  />
                </div>
              </div>


              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Profile Picture
                </label>
                <input
                  type="file"
                  name="profilePicture"
                  accept="image/*"
                  onChange={handleChange}
                  className="w-full"
                />
              </div>
            </div>

            <div className="space-y-4">
              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Password
                </label>
                <input
                  type="password"
                  name="password"
                  value={formData.password}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="••••••••"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Confirm Password
                </label>
                <input
                  type="password"
                  name="confirmPassword"
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="••••••••"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Clinic Name
                </label>
                <input
                  type="text"
                  name="clinicName"
                  value={formData.clinicName}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="OneApp Clinic"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Clinic Address
                </label>
                <input
                  type="text"
                  name="clinicAddress"
                  value={formData.clinicAddress}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="123 Main St, City"
                  required
                />
              </div>

              <div>
                <label className="block mb-1 text-md font-medium text-gray-900">
                  Clinic Location
                </label>
                <input
                  type="text"
                  name="location"
                  value={formData.location}
                  onChange={handleChange}
                  className="w-full border border-green-300 text-gray-900 text-sm rounded-lg p-2.5"
                  placeholder="Geo-location or use GPS"
                  required
                />
                <button
                  type="button"
                  onClick={() => handleUseGPS()}
                  className="mt-1 text-green-600 underline text-sm"
                >
                  📍 Use GPS | pick on map
                </button>
              </div>



            </div>

            <div className="col-span-1 md:col-span-2">
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-green-700 hover:bg-green-800 text-white font-medium rounded-lg text-md py-2.5 text-center"
              >
                {loading ? (
                  <>
                    <ClipLoader size={20} color="#ffffff" /> Creating...
                  </>
                ) : (
                  "Create Doctor Account"
                )}
              </button>
            </div>
            <Link
              to="/"
              className="text-black font-semibold text-md text-end "
            >
              Already have an account? <span className="text-green-700 underline">Sign in</span>
            </Link>
          </form>
        </div>

        {/* Right Side */}
        {/* <div className="hidden md:block w-1/2 relative">
          <img
            src={SignInBG}
            alt="Register BG"
            className="absolute inset-0 w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-green-900 bg-opacity-50 flex flex-col items-center justify-center text-white p-8">
            <h2 className="text-3xl font-bold mb-4">Welcome to OneApp!</h2>
            <p className="mb-6">
              Join OneApp to manage your practice seamlessly.
            </p>
            <Link
              to="/signin"
              className="text-green-300 font-semibold underline"
            >
              Already have an account? Sign in
            </Link>
          </div>
        </div> */}
      </div>
      {showMap && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-auto">
          <div className="bg-white rounded-lg shadow-lg p-4 w-full max-w-2xl">
            <h3 className="text-lg font-semibold mb-2">Pick Clinic Location</h3>
            <div className="h-[400px] w-full overflow-hidden rounded">
              <MapPicker
                latLng={gpsCoords}
                setAddress={(address) => {
                  setFormData({ ...formData, location: address });
                  setShowMap(false);
                }}
              />
            </div>
            <button
              onClick={() => setShowMap(false)}
              className="mt-2 text-red-600 underline text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      )}


    </section>
  );
};

export default DoctorRegistration;
