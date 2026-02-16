import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Lock, Mail, Loader2 } from 'lucide-react';
import { AppLogo } from '../components/ui/app-logo';

export function Login() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const { signIn } = useAuth();
    const navigate = useNavigate();

    const handleLogin = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        const { error } = await signIn(email, password);

        if (error) {
            setError(error.message);
            setLoading(false);
        } else {
            // Success! Redirect to dashboard
            navigate('/');
        }
    };

    return (
        <div className="flex items-center justify-center min-h-screen bg-gray-900 px-4">
            <div className="w-full max-w-md space-y-8 bg-gray-800 p-8 rounded-xl shadow-2xl border border-gray-700/50">
                <div className="flex flex-col items-center justify-center">
                    <AppLogo size="lg" className="mb-4 text-white" />
                    <p className="mt-2 text-sm text-gray-400">
                        Entre com suas credenciais de acesso
                    </p>
                </div>

                <form className="mt-8 space-y-6" onSubmit={handleLogin}>
                    <div className="rounded-md shadow-sm space-y-4">
                        <div>
                            <label htmlFor="email-address" className="sr-only">Endereço de Email</label>
                            <div className="relative">
                                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <Mail className="h-5 w-5 text-gray-500" />
                                </div>
                                <input
                                    id="email-address"
                                    name="email"
                                    type="email"
                                    autoComplete="email"
                                    required
                                    className="appearance-none rounded-lg relative block w-full px-3 py-3 pl-10 border border-gray-700 placeholder-gray-500 text-white bg-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm transition-colors"
                                    placeholder="Email de acesso"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            </div>
                        </div>
                        <div>
                            <label htmlFor="password" className="sr-only">Senha</label>
                            <div className="relative">
                                <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <Lock className="h-5 w-5 text-gray-500" />
                                </div>
                                <input
                                    id="password"
                                    name="password"
                                    type="password"
                                    autoComplete="current-password"
                                    required
                                    className="appearance-none rounded-lg relative block w-full px-3 py-3 pl-10 border border-gray-700 placeholder-gray-500 text-white bg-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm transition-colors"
                                    placeholder="Senha"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                />
                            </div>
                        </div>
                    </div>

                    {error && (
                        <div className="bg-red-900/30 border border-red-800 text-red-200 px-4 py-3 rounded relative text-sm" role="alert">
                            <span className="block sm:inline">{error}</span>
                        </div>
                    )}

                    <div>
                        <button
                            type="submit"
                            disabled={loading}
                            className="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg hover:shadow-blue-900/30"
                        >
                            {loading ? (
                                <Loader2 className="animate-spin h-5 w-5 text-white" />
                            ) : (
                                "Entrar no Sistema"
                            )}
                        </button>
                    </div>
                </form>
            </div >
        </div >
    );
}
