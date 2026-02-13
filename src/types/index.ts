export interface Client {
    id: string;
    user_id: string;
    name: string;
    system: 'winfood' | 'cplug';
    status: 'implantation' | 'active' | 'inactive';
    login_code?: string;
    system_login?: string;
    encrypted_password?: string;
    cnpj?: string;
    contact_info: ContactInfo[];
    integrations: IntegrationInfo[];
    created_at: string;
}

export interface ContactInfo {
    type: string;
    value: string;
    name?: string;
}

export interface IntegrationInfo {
    type: 'anydesk' | 'ifood' | 'anota_ai' | 'other';
    access_info: any; // Can be string or object depending on type
}

export interface Task {
    id: string;
    client_id: string;
    user_id: string;
    description: string;
    status: 'urgent' | 'in_progress' | 'pending' | 'done';
    created_at: string;
    updated_at: string;
    client?: Client; // Join
}

export interface Note {
    id: string;
    user_id: string;
    title: string;
    content: string;
    is_favorite: boolean;
    created_at: string;
    updated_at: string;
}
