import { useEffect, useState } from 'react';

function App() {
  const [data, setData] = useState(null);

  const fetchStatus = async () => {
    try {
      const response = await fetch('http://localhost:8080/api/status');
      const json = await response.json();
      setData(json);
    } catch (err) {
      console.error("Connection failed", err);
    }
  };

  useEffect(() => {
    // Poll every 2 seconds to see load balancing in action
    const interval = setInterval(fetchStatus, 2000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div style={{ padding: '20px', fontFamily: 'sans-serif' }}>
      <h1>Mini-Amazon Storefront</h1>
      {data ? (
        <div style={{ border: '1px solid #ccc', padding: '20px' }}>
          <p><strong>Status:</strong> {data.status}</p>
          <p><strong>Region:</strong> {data.region}</p>
          <p><strong>Container ID:</strong> {data.containerId}</p>
          <p><strong>Time:</strong> {data.timestamp}</p>
        </div>
      ) : (
        <p>Connecting to Load Balancer...</p>
      )}
    </div>
  );
}

export default App;