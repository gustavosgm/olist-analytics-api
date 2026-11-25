import { useEffect, useState } from 'react';
import {
  Typography, Table, TableHead, TableBody, TableRow, TableCell,
} from '@mui/material';

type Venda = {
  estado: string;
  unidades_vendidas: string;
  categoria_mais_vendida: string | null;
};

async function buscarVendas(): Promise<Venda[]> {
  const resposta = await fetch('/vendas/por-estado');
  if (!resposta.ok) {
    throw new Error('Não foi possível carregar as vendas.');
  }
  return resposta.json();
}

export default function App() {
  const [vendas, setVendas] = useState<Venda[] | null>(null);
  const [erro, setErro] = useState(false);

  useEffect(() => {
    buscarVendas()
      .then(setVendas)
      .catch(() => setErro(true));
  }, []);

  if (erro) return <Typography>Não foi possível carregar as vendas.</Typography>;
  if (vendas === null) return <Typography>Carregando vendas...</Typography>;

  return (
    <>
      <Typography variant="h4" component="h1">Vendas por estado</Typography>

      <Table aria-label="Vendas por estado">
        <TableHead>
          <TableRow>
            <TableCell>Estado</TableCell>
            <TableCell align="right">Unidades vendidas</TableCell>
            <TableCell>Categoria mais vendida</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {vendas.map((venda) => (
            <TableRow key={venda.estado}>
              <TableCell>{venda.estado}</TableCell>
              <TableCell align="right">
                {Number(venda.unidades_vendidas).toLocaleString('pt-BR')}
              </TableCell>
              <TableCell>
                {venda.categoria_mais_vendida?.replaceAll('_', ' ') ?? 'Sem categoria'}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </>
  );
}