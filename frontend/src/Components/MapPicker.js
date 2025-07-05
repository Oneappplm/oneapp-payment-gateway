import React, { useEffect, useState } from "react";
import "./mappickerstyles.css";
import { MapContainer, TileLayer, Marker, useMap, useMapEvents } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "leaflet-control-geocoder/dist/Control.Geocoder.css";
import "leaflet-control-geocoder";

export default function MapPicker({ latLng, setAddress }) {
  const [position, setPosition] = useState(latLng || [20, 77]);

  useEffect(() => {
    if (latLng) setPosition(latLng);
  }, [latLng]);

  const MapWithGeocoder = () => {
    const map = useMap();

    useEffect(() => {
      const geocoder = L.Control.Geocoder.nominatim();
      const control = L.Control.geocoder({
        position: "topright", // ✅ force visible
        placeholder: "Search address...",
        defaultMarkGeocode: false,
        geocoder
      })
        .on("markgeocode", function (e) {
          const { center } = e.geocode;
          setPosition([center.lat, center.lng]);
          map.setView([center.lat, center.lng], 16);
        })
        .addTo(map);

      return () => map.removeControl(control);
    }, [map]);

    useMapEvents({
      click(e) {
        const { lat, lng } = e.latlng;
        setPosition([lat, lng]);
        reverseGeocode(lat, lng);
      }
    });

    const reverseGeocode = async (lat, lng) => {
      const res = await fetch(
        `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`
      );
      const data = await res.json();
      setAddress(data.display_name);
    };

    return position === null ? null : <Marker position={position} />;
  };

  return (
    <MapContainer
      center={position}
      zoom={15}
      style={{ height: "100%", width: "100%", zIndex: 0 }} // ✅ z-index: 0 ensures Leaflet controls render above background but below modal overlays
      scrollWheelZoom
    >
      <TileLayer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <MapWithGeocoder />
    </MapContainer>
  );
}
